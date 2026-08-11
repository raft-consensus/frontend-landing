// ==========================================
// Qué hace: Realiza peticiones HTTP a los endpoints /api/me/ai-keys usando ApiClient.
// Dónde se conecta: Consumido por UserAiNotifier.
// De dónde recibe datos: Invoca a ApiClient adjuntando el JWT.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/user/data/models/ai_key_model.dart';

/// Fuente de datos remota encargada de los endpoints de API Keys de IA
class UserAiRemoteDatasource {
  UserAiRemoteDatasource({required this.apiClient});

  final ApiClient apiClient; // Cliente HTTP base

  /// Obtiene la lista completa de API Keys del usuario (GET /api/me/ai-keys)
  Future<List<AiKeyModel>> getAiKeys(String token) async {
    final response = await apiClient.get('/api/me/ai-keys', token: token);
    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];
    return dataList
        .map((json) => AiKeyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Crea una nueva API Key y devuelve el secreto único (POST /api/me/ai-keys)
  Future<Map<String, dynamic>> createAiKey(String name, String token) async {
    final response = await apiClient.post(
      '/api/me/ai-keys',
      body: {'name': name},
      token: token,
    );
    return response['data'] as Map<String, dynamic>;
  }

  /// Rota una API Key existente devolviendo un nuevo secreto (POST /api/me/ai-keys/{id}/rotate)
  Future<Map<String, dynamic>> rotateAiKey(String id, String token) async {
    final response = await apiClient.post(
      '/api/me/ai-keys/$id/rotate',
      body: {},
      token: token,
    );
    return response['data'] as Map<String, dynamic>;
  }

  /// Revoca/elimina definitivamente una API Key (DELETE /api/me/ai-keys/{id})
  Future<bool> deleteAiKey(String id, String token) async {
    final response = await apiClient.delete(
      '/api/me/ai-keys/$id',
      token: token,
    );
    // Si la respuesta fue HTTP 200/204 sin JSON o con success: true, asume éxito
    return response['success'] as bool? ?? true;
  }
}

/// Provider global de Riverpod para inyectar UserAiRemoteDatasource
final userAiRemoteDatasourceProvider = Provider<UserAiRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UserAiRemoteDatasource(apiClient: apiClient);
});
