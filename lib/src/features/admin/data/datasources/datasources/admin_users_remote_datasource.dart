// ==========================================
// Archivo: lib/src/features/admin/data/datasources/admin_users_remote_datasource.dart
// Qué hace: Realiza peticiones HTTP a los endpoints /api/users usando ApiClient.
// Dónde se conecta: Consumido por AdminUsersNotifier (presentation/providers).
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart) adjuntando el JWT.
// Nota: requiere que el usuario autenticado tenga rol Admin (política "AdminOnly" en el backend).
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/admin/data/models/admin_user_model.dart';

/// Fuente de datos remota encargada de consumir los endpoints de gestión de usuarios (admin)
class AdminUsersRemoteDatasource {
  AdminUsersRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene todos los usuarios registrados en la plataforma (GET /api/users)
  Future<List<AdminUserModel>> getAllUsers(String token) async {
    final response = await apiClient.get('/api/users', token: token);

    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];

    return dataList
        .map((json) => AdminUserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Suspende (soft-delete) a un usuario (DELETE /api/users/{id})
  ///
  /// Nota importante: el backend NO expone un endpoint para "reactivar" un usuario
  /// suspendido (no existe un PATCH/restore de DeletedAt). Esta llamada solo cubre
  /// la mitad del ciclo suspender/reactivar que muestra la UI; ver AdminUsersNotifier.
  Future<void> suspendUser(int userId, String token) async {
    await apiClient.delete('/api/users/$userId', token: token);
  }

  /// Elimina definitivamente (soft-delete) a un usuario (DELETE /api/users/{id})
  ///
  /// El backend expone una única operación de baja (soft-delete), por lo que
  /// "suspender" y "eliminar" en la UI terminan llamando al mismo endpoint.
  Future<void> deleteUser(int userId, String token) async {
    await apiClient.delete('/api/users/$userId', token: token);
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de AdminUsersRemoteDatasource
final adminUsersRemoteDatasourceProvider =
    Provider<AdminUsersRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return AdminUsersRemoteDatasource(apiClient: apiClient);
    });
