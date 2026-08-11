// ==========================================
// Qué hace: Realiza peticiones HTTP a los endpoints /api/me/databases usando ApiClient.
// Dónde se conecta: Consumido por el repositorio de bases de datos del usuario.
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart) adjuntando el JWT.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/user/data/models/database_model.dart';

/// Fuente de datos remota encargada de consumir los endpoints de bases de datos del usuario
class UserDatabasesRemoteDatasource {
  UserDatabasesRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene la lista de bases de datos pertenecientes al usuario autenticado (GET /api/me/databases)
  Future<List<DatabaseModel>> getMyDatabases(String token) async {
    final response = await apiClient.get('/api/me/databases', token: token);

    // Lee la lista contenida dentro de la propiedad 'data' del sobre de respuesta
    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];

    // Convierte cada elemento JSON en un objeto DatabaseModel
    return dataList
        .map((json) => DatabaseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Revela la contraseña de una instancia específica (GET /api/me/databases/{id}/password)
  Future<String> revealPassword(int databaseInstanceId, String token) async {
    final response = await apiClient.get(
      '/api/me/databases/$databaseInstanceId/password',
      token: token,
    );

    // Extrae la contraseña devuelta dentro del mapa 'data'
    final data = response['data'] as Map<String, dynamic>?;
    return data?['password'] as String? ?? '';
  }

  /// Envía la solicitud de aprovisionamiento con el motor seleccionado (POST /api/me/databases)
  Future<Map<String, dynamic>> createDatabase({
    required String engine,
    required String token,
  }) async {
    final response = await apiClient.post(
      '/api/me/databases',
      body: {'engine': engine},
      token: token,
    );
    return response['data'] as Map<String, dynamic>;
  }

  /// Solicita pausar/detener una instancia específica (POST /api/me/databases/{id}/pause)
  Future<bool> pauseDatabase(int databaseInstanceId, String token) async {
    final response = await apiClient.post(
      '/api/me/databases/$databaseInstanceId/pause',
      token: token, body: {},
    );
    return response['success'] as bool? ?? false;
  }

  /// Solicita reanudar/iniciar una instancia específica (POST /api/me/databases/{id}/resume)
  Future<bool> resumeDatabase(int databaseInstanceId, String token) async {
    final response = await apiClient.post(
      '/api/me/databases/$databaseInstanceId/resume',
      token: token, body: {},
    );
    return response['success'] as bool? ?? false;
  }

  /// Solicita eliminar una instancia específica de forma definitiva (DELETE /api/me/databases/{id})
  Future<bool> deleteDatabase(int databaseInstanceId, String token) async {
    final response = await apiClient.delete(
      '/api/me/databases/$databaseInstanceId',
      token: token,
    );
    return response['success'] as bool? ?? false;
  }
} // 👈 La clase UserDatabasesRemoteDatasource cierra AQUÍ

/// Proveedor global de Riverpod para inyectar la instancia de UserDatabasesRemoteDatasource
final userDatabasesRemoteDatasourceProvider =
    Provider<UserDatabasesRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return UserDatabasesRemoteDatasource(apiClient: apiClient);
    });
