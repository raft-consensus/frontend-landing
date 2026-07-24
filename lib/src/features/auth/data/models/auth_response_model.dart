import '../../domain/entities/auth_session.dart';
import 'user_model.dart';

/// Modelo de datos que convierte la respuesta JSON completa de autenticación en una AuthSession.
/// 
/// ¿De dónde recibe datos?: Del objeto "data" en la respuesta JSON de /api/auth/login o /api/auth/register.
/// ¿Hacia dónde va / Dónde se conecta?: Retornada por AuthRemoteDataSource hacia el AuthRepositoryImpl.
class AuthResponseModel extends AuthSession {
  const AuthResponseModel({
    required super.accessToken,
    required super.provider,
    required super.user,
    super.expiresAt,
  });

  /// Construye una instancia de AuthResponseModel a partir del mapa JSON "data".
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String? ?? '',
      provider: json['provider'] as String? ?? 'Password',
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      expiresAt: json['expiresAt'] != null 
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }
}
