import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';

/// Fuente de datos remota para consultar y actualizar el perfil del usuario.
/// 
/// ¿Qué hace?: Realiza llamadas a GET /api/me/profile y PUT /api/me/profile sanitizando cadenas vacías a null.
/// ¿De dónde recibe datos?: Del ApiClient pasándole el Token JWT.
/// ¿Hacia dónde se conecta?: Al backend ASP.NET Core en la ruta /api/me/profile.
class UserProfileRemoteDataSource {
  UserProfileRemoteDataSource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene los datos del perfil del usuario autenticado
  Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await apiClient.get('/api/me/profile', token: token);
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  /// Actualiza los campos permitidos del perfil convirtiendo cadenas vacías a null para validación C#
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String? organization,
    required String? phone,
    required String? gender,
    required String? birthDate,
    required String? country,
    required String token,
  }) async {
    final String? cleanBirthDate = (birthDate != null && birthDate.trim().isNotEmpty) ? birthDate : null;
    final String? cleanPhone = (phone != null && phone.trim().isNotEmpty) ? phone : null;
    final String? cleanOrg = (organization != null && organization.trim().isNotEmpty) ? organization : null;
    final String? cleanGender = (gender != null && gender.trim().isNotEmpty) ? gender : null;
    final String? cleanCountry = (country != null && country.trim().isNotEmpty) ? country : null;

    final response = await apiClient.put(
      '/api/me/profile',
      token: token,
      body: {
        'name': name,
        'organization': cleanOrg,
        'phone': cleanPhone,
        'gender': cleanGender,
        'birthDate': cleanBirthDate,
        'country': cleanCountry,
      },
    );
    return response['data'] as Map<String, dynamic>? ?? {};
  }
}

/// Provider para inyectar UserProfileRemoteDataSource
final userProfileRemoteDataSourceProvider = Provider<UserProfileRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserProfileRemoteDataSource(apiClient: apiClient);
});
