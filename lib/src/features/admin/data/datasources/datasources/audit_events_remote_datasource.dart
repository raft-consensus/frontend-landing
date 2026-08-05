// ==========================================
// Archivo: lib/src/features/admin/data/datasources/audit_events_remote_datasource.dart
// Qué hace: Realiza peticiones HTTP a los endpoints /api/audit-events usando ApiClient.
// Dónde se conecta: Consumido por AdminAuditNotifier (presentation/providers).
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart) adjuntando el JWT.
// Nota: requiere que el usuario autenticado tenga rol Admin (política "AdminOnly" en el backend).
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/admin/data/models/audit_event_model.dart';

/// Fuente de datos remota encargada de consumir los endpoints del registro de auditoría
class AuditEventsRemoteDatasource {
  AuditEventsRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene todos los eventos de auditoría registrados (GET /api/audit-events)
  Future<List<AuditEventModel>> getAllEvents(String token) async {
    final response = await apiClient.get('/api/audit-events', token: token);

    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];

    return dataList
        .map((json) => AuditEventModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de AuditEventsRemoteDatasource
final auditEventsRemoteDatasourceProvider =
    Provider<AuditEventsRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return AuditEventsRemoteDatasource(apiClient: apiClient);
    });
