/// ¿Qué hace?: Objeto de transferencia de datos (DTO) para empaquetar las credenciales del formulario de Inicio de Sesión.
/// ¿De dónde trae?: Se compone de tipos primitivos (String, bool).
/// ¿Hacia dónde va / Cómo se conecta?: Se envía desde LoginCard / LoginScreen hacia AuthRemoteDataSource para la petición HTTP.
class LoginFormData {
  const LoginFormData({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;

  /// Convierte el modelo a un mapa JSON exacto para el endpoint POST /api/auth/login
  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'password': password,
    };
  }
}
