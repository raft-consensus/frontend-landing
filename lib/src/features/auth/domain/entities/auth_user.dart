/// Entidad pura de la capa de dominio que representa al usuario autenticado.
/// 
/// ¿De dónde recibe datos?: Mapeado desde UserModel en la capa Data.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por AuthSession y las pantallas de perfil/dashboard.
class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? createdAt;
}
