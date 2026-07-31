// ==========================================
// Archivo: lib/src/features/user/data/datasources/user_databases_remote_datasource.dart
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

  /// ¿Hacia dónde se conecta?: Backend ASP.NET Core (`POST /api/me/databases`).
  Future<DatabaseModel> createDatabase({required String token}) async {
    // El endpoint de autoservicio no requiere cuerpo en el request; la VPS genera la BD y las credenciales automáticamente.
    final response = await apiClient.post(
      '/api/me/databases',
      body: {},
      token: token,
    );
    // Mapea la propiedad 'data' del JSON recibido hacia el modelo de dominio DatabaseModel
    final data = response['data'] as Map<String, dynamic>;
    return DatabaseModel.fromJson({
      'databaseInstanceId': data['databaseInstanceId'] ?? 0,
      'host': data['host'] ?? '',
      'port': data['port'] ?? 3306,
      'databaseName': data['databaseName'] ?? '',
      'databaseUser': data['databaseUser'] ?? '',
      'engine': data['engine'] ?? 'MySQL',
      'status': 'Active',
      'usedSpaceBytes': 0,
      'maxSpaceBytes': 20971520, // 20 MB límite asignado por el backend
      'createdAt': DateTime.now().toIso8601String(),
    });
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de UserDatabasesRemoteDatasource
final userDatabasesRemoteDatasourceProvider =
    Provider<UserDatabasesRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return UserDatabasesRemoteDatasource(apiClient: apiClient);
    });
