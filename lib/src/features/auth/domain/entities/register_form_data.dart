
/// ¿Qué hace?: Objeto de transferencia de datos (DTO) para empaquetar la información del formulario de Registro.
/// ¿De dónde trae?: Se compone de tipos primitivos (String, bool).
/// ¿Hacia dónde va / Cómo se conecta?: Se envía desde RegisterCard / RegisterScreen hacia AuthRemoteDataSource para la petición HTTP.
class RegisterFormData {
  const RegisterFormData({
    required this.name,
    required this.email,
    required this.password,
    required this.acceptTerms,
  });

  final String name;
  final String email;
  final String password;
  final bool acceptTerms;

  /// Convierte la instancia en un mapa JSON exacto para el endpoint POST /api/auth/register
  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
    };
  }
}
