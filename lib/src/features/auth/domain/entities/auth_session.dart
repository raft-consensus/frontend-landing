import 'auth_user.dart';

/// Entidad pura de dominio que representa la sesión activa de autenticación.
/// 
/// ¿De dónde recibe datos?: Mapeado desde AuthResponseModel en la capa Data.
/// ¿Hacia dónde va / Dónde se conecta?: Retornada por AuthRepository para ser guardada en AuthProvider.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.provider,
    required this.user,
    this.expiresAt,
  });

  final String accessToken;
  final String provider; // 'local', 'google', 'github'
  final AuthUser user;
  final DateTime? expiresAt;
}
