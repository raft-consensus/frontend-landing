// ==========================================
// Archivo: lib/src/features/user/data/datasources/user_databases_remote_datasource.dart
// Qué hace: Realiza peticiones HTTP a los endpoints /api/me/databases usando ApiClient.
// Dónde se conecta: Consumido por el repositorio de bases de datos del usuario.
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart) adjuntando el JWT.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/user/data/models/database_model.dart';
import 'package:frontend_landing/src/features/user/data/models/provisioning_result_model.dart';

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

  /// Solicita el aprovisionamiento de una nueva instancia MySQL propia (POST /api/me/databases).
  ///
  /// A diferencia del endpoint admin (/api/database-instances), este NO recibe body: el
  /// nombre, usuario y contraseña los genera el servidor (ver MySqlProvisioningService en
  /// el backend). El userId se resuelve del JWT, nunca se envía en el request.
  Future<ProvisioningResultModel> createDatabase({required String token}) async {
    final response = await apiClient.post('/api/me/databases', token: token);

    final data = response['data'] as Map<String, dynamic>;
    return ProvisioningResultModel.fromJson(data);
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de UserDatabasesRemoteDatasource
final userDatabasesRemoteDatasourceProvider =
    Provider<UserDatabasesRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return UserDatabasesRemoteDatasource(apiClient: apiClient);
    });
