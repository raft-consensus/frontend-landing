/// Objeto de transferencia de datos (DTO) para enviar la información del formulario de registro al backend.
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

  /// Convierte la instancia del modelo en un mapa JSON para ser enviado en peticiones HTTP POST.
  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'accept_terms': acceptTerms,
    };
  }

  /// Crea una instancia del modelo a partir de una respuesta JSON (si el backend retorna los datos del registro).
  factory RegisterFormData.fromJson(Map<String, dynamic> json) {
    return RegisterFormData(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: '', // Por seguridad no se almacena la contraseña recibida
      acceptTerms: json['accept_terms'] as bool? ?? false,
    );
  }
}
