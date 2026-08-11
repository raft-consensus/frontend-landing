import 'package:frontend_landing/src/features/auth/domain/entities/auth_session.dart';

/// Estructura inmutable que representa el estado global de la autenticación.
/// 
/// ¿Qué hace?: Almacena los estados de carga, autenticación, datos de sesión y mensajes de error.
/// ¿De dónde recibe datos?: Modificado mediante AuthNotifier.copyWith.
/// ¿Hacia dónde se conecta?: Consumido por vistas y widgets de la aplicación.
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
