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

  /// Envía la solicitud para crear una instancia de SQL Server en nuestra VPS (POST /api/database-instances)
  Future<DatabaseModel> createDatabase({
    required String name,
    required String engine,
    required String token,
  }) async {
    // Genera un nombre de base de datos y usuario seguros a partir del nombre ingresado
    final slug = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final isSqlServer = engine.toLowerCase().contains('sql');

    final body = {
      'host': 'api.raft.andrescortes.dev',
      'port': isSqlServer
          ? 1433
          : 3306, // Puerto 1433 asignado a nuestra VPS para SQL Server
      'databaseName': '${slug}_db',
      'databaseUser': 'user_$slug',
      'engine': engine,
      'status': 'Active',
      'usedSpaceBytes': 0,
      'maxSpaceBytes': 524288000, // 512 MB de espacio limite
    };

    final response = await apiClient.post(
      '/api/database-instances',
      body: body,
      token: token,
    );

    final data = response['data'] as Map<String, dynamic>;
    return DatabaseModel.fromJson(data);
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de UserDatabasesRemoteDatasource
final userDatabasesRemoteDatasourceProvider =
    Provider<UserDatabasesRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return UserDatabasesRemoteDatasource(apiClient: apiClient);
    });
