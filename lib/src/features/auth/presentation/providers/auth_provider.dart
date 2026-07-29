// ==========================================
// Archivo: lib/src/features/auth/presentation/providers/auth_provider.dart
// Qué hace: Controla el estado inmutable de sesión, guardado de token y parseo de JWT.
// Dónde se conecta: Consumido por LoginPage, AuthCallbackPage y AppRouter.
// De dónde recibe datos: AuthRepositoryImpl y AuthCallbackPage.
// ==========================================

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_session.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_user.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/register_form_data.dart';

/// Estructura inmutable del estado de autenticación
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

/// Notificador que controla las acciones de autenticación
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.repository}) : super(const AuthState()) {
    checkAuthStatus();
  }

  final AuthRepositoryImpl repository;

  /// Verifica si existe un token guardado localmente al iniciar la app
  Future<void> checkAuthStatus() async {
    final token = await repository.getSavedToken();

    if (token != null && token.isNotEmpty) {
      final user = _parseUserFromJwt(token, 'Local');
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        session: AuthSession(
          accessToken: token,
          provider: 'Local',
          user: user,
        ),
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
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
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
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
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  /// Establece la sesión activa al recibir el token de OAuth (Google/GitHub)
  Future<bool> setSessionFromOAuth(String token, String provider) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Guardar el token en el almacenamiento persistente
      await repository.sessionStorage.saveToken(token);

      // Decodificar los datos del usuario contenidos en el JWT
      final user = _parseUserFromJwt(token, provider);
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
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al guardar la sesión de OAuth.',
      );
      return false;
    }
  }

  /// Parsea el payload del JWT soportando claims estándar y de ASP.NET Core
  AuthUser _parseUserFromJwt(String token, String provider) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('JWT inválido');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decodedString = utf8.decode(base64Url.decode(normalized));
      final Map<String, dynamic> claims = jsonDecode(decodedString);

      // Mapeo del claim de Rol
      final roleClaim = claims['role'] ??
          claims['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          'User';

      // Mapeo del claim de ID
      final idClaim = claims['sub'] ??
          claims['nameid'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier'] ??
          '0';

      // Mapeo del claim de Nombre
      final nameClaim = claims['name'] ??
          claims['unique_name'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
          'Usuario $provider';

      // Mapeo del claim de Email
      final emailClaim = claims['email'] ??
          claims['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
          '';

      return AuthUser(
        id: idClaim.toString(),
        name: nameClaim.toString(),
        email: emailClaim.toString(),
        role: roleClaim.toString(),
      );
    } catch (_) {
      return AuthUser(
        id: '0',
        name: 'Usuario $provider',
        email: '',
        role: 'User',
      );
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
  return AuthNotifier(repository: repository);
});
