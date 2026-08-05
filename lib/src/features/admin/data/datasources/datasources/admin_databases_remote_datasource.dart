// ==========================================
// Archivo: lib/src/features/admin/data/datasources/admin_databases_remote_datasource.dart
// Qué hace: Realiza peticiones HTTP a los endpoints /api/database-instances usando ApiClient.
// Dónde se conecta: Consumido por AdminDatabasesNotifier (presentation/providers).
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart) adjuntando el JWT.
// Nota: requiere que el usuario autenticado tenga rol Admin (política "AdminOnly" en el backend).
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/admin/data/models/managed_database_model.dart';

/// Fuente de datos remota encargada de consumir los endpoints de administración de instancias
class AdminDatabasesRemoteDatasource {
  AdminDatabasesRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene todas las instancias de bases de datos de la plataforma (GET /api/database-instances)
  Future<List<ManagedDatabaseModel>> getAllDatabases(String token) async {
    final response = await apiClient.get(
      '/api/database-instances',
      token: token,
    );

    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];

    return dataList
        .map(
          (json) => ManagedDatabaseModel.fromJson(json as Map<String, dynamic>),
        )
        .toList();
  }

  /// Actualiza el estado (Active/Suspended) de una instancia (PUT /api/database-instances/{id})
  ///
  /// El backend exige reenviar el objeto completo (DatabaseInstanceUpdateDto), por lo
  /// que [body] debe construirse a partir del último ManagedDatabaseModel conocido
  /// (ver ManagedDatabaseModel.toUpdateJson).
  Future<void> updateStatus({
    required int databaseInstanceId,
    required Map<String, dynamic> body,
    required String token,
  }) async {
    await apiClient.put(
      '/api/database-instances/$databaseInstanceId',
      body: body,
      token: token,
    );
  }

  /// Elimina (soft-delete) una instancia de base de datos (DELETE /api/database-instances/{id})
  Future<void> deleteDatabase(int databaseInstanceId, String token) async {
    await apiClient.delete(
      '/api/database-instances/$databaseInstanceId',
      token: token,
    );
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de AdminDatabasesRemoteDatasource
final adminDatabasesRemoteDatasourceProvider =
    Provider<AdminDatabasesRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return AdminDatabasesRemoteDatasource(apiClient: apiClient);
    });
