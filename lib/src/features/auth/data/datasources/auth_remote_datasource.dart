import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/auth/data/models/auth_response_model.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/register_form_data.dart';

/// Fuente de datos remota para el módulo de autenticación.
///
/// ¿De dónde recibe datos?: Del ApiClient (cliente HTTP base).
/// ¿Hacia dónde va / Dónde se conecta?: Realiza peticiones a /api/auth/register y /api/auth/login.
class AuthRemoteDataSource {
  AuthRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  /// Envía la solicitud de registro al servidor backend.
  Future<AuthResponseModel> register(RegisterFormData formData) async {
    final response = await apiClient.post(
      '/api/auth/register',
      body: formData.toJson(),
    );

    final Map<String, dynamic> data =
        response['data'] as Map<String, dynamic>? ?? {};
    return AuthResponseModel.fromJson(data);
  }

  /// Envía la solicitud de inicio de sesión al servidor backend.
  Future<AuthResponseModel> login(LoginFormData formData) async {
    final response = await apiClient.post(
      '/api/auth/login',
      body: formData.toJson(),
    );

    final Map<String, dynamic> data =
        response['data'] as Map<String, dynamic>? ?? {};
    return AuthResponseModel.fromJson(data);
  }

  /// Envía la solicitud de recuperación de contraseña al backend real.
  Future<void> recoverPassword(String email) async {
    await apiClient.post('/api/auth/forgot-password', body: {'email': email});
  }

  /// Envía la solicitud de cambio de contraseña al servidor backend.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String token,
  }) async {
    await apiClient.post(
      '/api/auth/change-password',
      token: token,
      body: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}

/// Proveedor de Riverpod para inyectar AuthRemoteDataSource.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSource(apiClient: apiClient);
});
