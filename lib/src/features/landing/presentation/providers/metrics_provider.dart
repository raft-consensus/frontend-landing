import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/landing/data/datasources/metrics_remote_datasource.dart';
import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';

/// Provider de Riverpod que expone de forma asíncrona las métricas globales de la plataforma.
/// 
/// ¿Qué hace?: Ejecuta la consulta al DataSource remoto y gestiona reactivamente el estado de la petición (loading, data, error).
/// ¿De dónde recibe datos?: Invocación al método getPlatformMetrics() de metricsRemoteDataSourceProvider.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por el widget de UI MetricsSection mediante ref.watch(platformMetricsProvider).
final platformMetricsProvider = FutureProvider<PlatformMetrics>((ref) async {
  final dataSource = ref.watch(metricsRemoteDataSourceProvider);
  return await dataSource.getPlatformMetrics();
});
