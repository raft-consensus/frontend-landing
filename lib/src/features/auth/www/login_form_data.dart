/// Objeto de transferencia de datos (DTO) para enviar las credenciales del formulario de login al backend.
class LoginFormData {
  const LoginFormData({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  final String email;
  final String password;
  final bool rememberMe;

  /// Convierte el modelo a un mapa JSON para ser enviado en peticiones HTTP POST de inicio de sesión.
  Map<String, dynamic> toJson() {
    return {
      'email': email.trim(),
      'password': password,
      'remember_me': rememberMe,
    };
  }
}
