// ==========================================
// Qué hace: Tarjeta resumen modular del consumo total de almacenamiento y estado del clúster de bases de datos.
// Dónde se conecta: Se ubica en la parte superior de DatabasesPage.
// De dónde recibe datos: Recibe la lista de List<DatabaseInstance> para calcular acumulados.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/summary/summary_metric_tile.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/summary/summary_storage_section.dart'; // Databases

/// Tarjeta resumen del clúster de bases de datos compuesta por subwidgets limpios
class DatabaseSummaryCard extends StatelessWidget {
  const DatabaseSummaryCard({
    required this.instances, // Lista completa de instancias de bases de datos
    super.key,
  });

  final List<DatabaseInstance> instances;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Cálculo acumulado del consumo global de almacenamiento y estado de instancias
    final int totalUsedBytes = instances.fold(0, (sum, db) => sum + db.usedSpaceBytes);
    final int totalLimitBytes = instances.fold(0, (sum, db) => sum + db.maxSpaceBytes);
    final int activeCount = instances.where((db) => db.isRunning).length;
    final int totalCount = instances.length;
    final double progress = totalLimitBytes > 0
        ? (totalUsedBytes / totalLimitBytes).clamp(0.0, 1.0)
        : 0.0;
    final int percentage = (progress * 100).toInt();

    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;

          return Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isCompact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              // Bloque 1: Consumo acumulado de almacenamiento con barra de progreso global
              Expanded(
                flex: isCompact ? 0 : 3,
                child: SummaryStorageSection(
                  totalUsedBytes: totalUsedBytes,
                  totalLimitBytes: totalLimitBytes,
                  progress: progress,
                  percentage: percentage,
                ),
              ),

              if (!isCompact) ...[
                const SizedBox(width: 24),
                Container(height: 54, width: 1, color: theme.dividerColor),
                const SizedBox(width: 24),
              ] else
                const SizedBox(height: 18),

              // Bloque 2: Resumen rápido de instancias activas y estado del clúster
              Expanded(
                flex: isCompact ? 0 : 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SummaryMetricTile(
                      label: 'Instancias Activas',
                      value: '$activeCount / $totalCount',
                      icon: Icons.power_settings_new_rounded,
                      iconColor: AppColors.success,
                    ),
                    SummaryMetricTile(
                      label: 'Estado del Clúster',
                      value: activeCount == totalCount ? 'Óptimo' : 'Parcial',
                      icon: Icons.health_and_safety_rounded,
                      iconColor: activeCount == totalCount
                          ? AppColors.success
                          : AppColors.warning,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
