import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_session.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/register_form_data.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_state.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/jwt_decoder.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_activity_provider.dart';

// Exporta AuthState para mantener compatibilidad con las pantallas que lo importan directamente
export 'package:frontend_landing/src/features/auth/presentation/providers/auth_state.dart';

/// Notificador que controla las acciones del ciclo de vida de autenticación.
///
/// ¿Qué hace?: Gestiona inicio de sesión, registro, recuperación/cambio de contraseña y sesión OAuth.
/// ¿De dónde recibe datos?: Invoca AuthRepositoryImpl y utiliza JwtDecoder para procesar tokens.
/// ¿Hacia dónde se conecta?: Expuesto a través de authProvider para la interfaz gráfica.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.repository, required this.ref})
    : super(const AuthState()) {
    checkAuthStatus();
  }

  final AuthRepositoryImpl repository;
  final Ref ref;

  /// Verifica si existe un token guardado localmente y valida su expiración
  Future<void> checkAuthStatus() async {
    final token = await repository.getSavedToken();
    if (token != null && token.isNotEmpty) {
      final isExpired = JwtDecoder.isExpired(token);
      if (isExpired) {
        await repository.logout();
        state = state.copyWith(isLoading: false, isAuthenticated: false);
        return;
      }
      final user = JwtDecoder.parseUser(token, 'Local');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: AuthSession(accessToken: token, provider: 'Local', user: user),
      );

      // REGISTRAR INICIO DE SESIÓN RECONECTADO REAL
      ref
          .read(userActivityProvider.notifier)
          .addActivity(
            title: 'Inicio de Sesión',
            desc: 'Acceso exitoso al panel de control de Raft DB',
            type: ActivityType.login,
          );
    } else {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  /// Inicia sesión mediante formulario
  Future<bool> login(LoginFormData formData) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final session = await repository.login(formData);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: session,
      );
      // REGISTRAR INICIO DE SESIÓN REAL
      ref
          .read(userActivityProvider.notifier)
          .addActivity(
            title: 'Inicio de Sesión',
            desc: 'Acceso exitoso con contraseña',
            type: ActivityType.login,
          );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Registra un usuario mediante formulario
  Future<bool> register(RegisterFormData formData) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final session = await repository.register(formData);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: session,
      );
      // REGISTRAR REGISTRO Y BIENVENIDA REAL
      ref
          .read(userActivityProvider.notifier)
          .addActivity(
            title: 'Cuenta Creada',
            desc: 'Registro exitoso en el clúster Raft DB',
            type: ActivityType.login,
          );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }

  /// Envía la solicitud de recuperación de contraseña al servidor
  Future<bool> recoverPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await repository.recoverPassword(email);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// Solicita la actualización de la contraseña del usuario activo
  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }

  /// Establece la sesión activa al recibir el token de OAuth (Google/GitHub)
  Future<bool> setSessionFromOAuth(String token, String provider) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await repository.sessionStorage.saveToken(token);
      final user = JwtDecoder.parseUser(token, provider);
      final session = AuthSession(
        accessToken: token,
        provider: provider,
        user: user,
      );
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: session,
      );
      // REGISTRAR INICIO DE SESIÓN OAUTH REAL
      ref
          .read(userActivityProvider.notifier)
          .addActivity(
            title: 'Inicio de Sesión',
            desc: 'Acceso exitoso vía $provider',
            type: ActivityType.login,
          );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar la sesión de OAuth.',
      );
      return false;
    }
  }

  /// Cierra la sesión del usuario
  Future<void> logout() async {
    await repository.logout();
    state = const AuthState(isAuthenticated: false);
  }
}

/// Proveedor de Riverpod para consultar el estado global de Autenticación
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository, ref: ref);
});
