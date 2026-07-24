import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_session.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/register_form_data.dart';

/// Define la estructura inmutable del estado de autenticación.
class AuthState {
  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.session,
    this.errorMessage,
  });

  final bool isLoading;
  final bool isAuthenticated;
  final AuthSession? session;
  final String? errorMessage;

  /// Crea una copia del estado modificando solo los campos especificados.
  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    AuthSession? session,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      session: session ?? this.session,
      errorMessage: errorMessage,
    );
  }
}

/// Notificador de estado que controla las acciones de inicio de sesión, registro y logout.
/// 
/// ¿De dónde recibe datos?: Consume AuthRepositoryImpl.
/// ¿Hacia dónde va / Dónde se conecta?: Escuchado por las pantallas de Login/Register y GoRouter.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.repository}) : super(const AuthState()) {
    checkAuthStatus();
  }

  final AuthRepositoryImpl repository;

  /// Revisa al iniciar la app si existe un token guardado localmente.
  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    final token = await repository.getSavedToken();

    if (token != null && token.isNotEmpty) {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  /// Ejecuta el proceso de inicio de sesión con correo y contraseña.
  Future<bool> login(LoginFormData formData) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await repository.login(formData);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: session,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error de conexión inesperado',
      );
      return false;
    }
  }

  /// Ejecuta el proceso de registro de un nuevo usuario.
  Future<bool> register(RegisterFormData formData) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final session = await repository.register(formData);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: session,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al registrar el usuario',
      );
      return false;
    }
  }

  /// Cierra la sesión activa del usuario.
  Future<void> logout() async {
    await repository.logout();
    state = const AuthState(isAuthenticated: false);
  }
}

/// Proveedor de Riverpod para consultar y reaccionar al estado de autenticación.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository: repository);
});
