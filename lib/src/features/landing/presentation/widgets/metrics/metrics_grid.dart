import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metric_card.dart';

/// Grilla responsiva que organiza las 4 tarjetas de métricas en la pantalla.
/// 
/// ¿Qué hace?: Mapea la entidad de dominio PlatformMetrics en una grilla Wrap conteniendo tarjetas MetricCard.
/// ¿De dónde recibe datos?: Entidad de dominio PlatformMetrics provista por MetricsSection.
/// ¿Hacia dónde va / Dónde se conecta?: Renderizado en el estado de éxito 'data' de MetricsSection.
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({
    required this.metrics,
    super.key,
  });

  final PlatformMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        MetricCard(
          icon: Icons.people_outline_rounded,
          value: '${metrics.totalUsers}',
          label: 'Usuarios Registrados',
          color: AppColors.blue,
        ),
        MetricCard(
          icon: Icons.storage_rounded,
          value: '${metrics.totalDatabases}',
          label: 'Bases de Datos Creadas',
          color: AppColors.cyan,
        ),
        MetricCard(
          icon: Icons.cloud_done_rounded,
          value: '${metrics.activeDatabases}',
          label: 'Bases de Datos Activas',
          color: AppColors.green,
        ),
        MetricCard(
          icon: Icons.verified_rounded,
          value: '${metrics.serviceAvailability.toStringAsFixed(1)}%',
          label: 'Disponibilidad Servicio',
          color: AppColors.purple,
        ),
      ],
    );
  }
}
