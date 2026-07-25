import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/landing/data/models/platform_metrics_model.dart';
import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';

/// Interfaz abstracta para el DataSource remoto de métricas.
abstract class MetricsRemoteDataSource {
  Future<PlatformMetrics> getPlatformMetrics();
}

/// Implementación concreta del DataSource que realiza la petición HTTP mediante ApiClient.
/// 
/// ¿Qué hace?: Consulta el endpoint '/api/metrics/platform' y convierte el mapa de respuesta en una entidad PlatformMetrics.
/// ¿De dónde recibe datos?: Peticiones HTTP procesadas por la clase ApiClient.
/// ¿Hacia dónde va / Dónde se conecta?: Provee los datos a los providers de estado de Riverpod.
class MetricsRemoteDataSourceImpl implements MetricsRemoteDataSource {
  MetricsRemoteDataSourceImpl({
    required this._apiClient
    });

  final ApiClient _apiClient;

  @override
  Future<PlatformMetrics> getPlatformMetrics() async {
    // Realiza la petición HTTP GET al endpoint público de métricas
    final response = await _apiClient.get('/api/metrics/platform');

    // La respuesta del backend viene en el formato envoltorio { success: true, message: "...", data: { ... } }
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return PlatformMetricsModel.fromJson(data);
    }

    throw ApiException('La respuesta del servidor no contiene una estructura de métricas válida');
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de MetricsRemoteDataSource.
final metricsRemoteDataSourceProvider = Provider<MetricsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MetricsRemoteDataSourceImpl(apiClient: apiClient);
});
