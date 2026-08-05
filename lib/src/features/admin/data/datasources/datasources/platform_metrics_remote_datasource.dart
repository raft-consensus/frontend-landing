// ==========================================
// Archivo: lib/src/features/admin/data/datasources/platform_metrics_remote_datasource.dart
// Qué hace: Realiza la petición HTTP al endpoint /api/metrics/platform usando ApiClient.
// Dónde se conecta: Consumido por AdminMetricsNotifier (presentation/providers).
// De dónde recibe datos: Invoca a ApiClient (core/network/api_client.dart).
// Nota: este endpoint es público en el backend (no tiene [Authorize]), pero se envía
// el token igual por consistencia con el resto de los datasources del panel admin.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/admin/data/models/platform_metrics_model.dart';

/// Fuente de datos remota encargada de consumir el endpoint de métricas globales
class PlatformMetricsRemoteDatasource {
  PlatformMetricsRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene los indicadores globales de la plataforma (GET /api/metrics/platform)
  Future<PlatformMetricsModel> getPlatformMetrics({String? token}) async {
    final response = await apiClient.get(
      '/api/metrics/platform',
      token: token,
    );

    final data = response['data'] as Map<String, dynamic>? ?? {};
    return PlatformMetricsModel.fromJson(data);
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de PlatformMetricsRemoteDatasource
final platformMetricsRemoteDatasourceProvider =
    Provider<PlatformMetricsRemoteDatasource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      return PlatformMetricsRemoteDatasource(apiClient: apiClient);
    });
