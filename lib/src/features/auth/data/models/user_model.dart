import '../../domain/entities/auth_user.dart';

/// Modelo de datos que convierte la respuesta JSON del usuario en la entidad AuthUser.
/// 
/// ¿De dónde recibe datos?: Del objeto "user" en la respuesta JSON del backend.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado por AuthResponseModel para parsear los datos del usuario.
class UserModel extends AuthUser {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.createdAt,
  });

  /// Construye una instancia de UserModel a partir de un mapa JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }
}
