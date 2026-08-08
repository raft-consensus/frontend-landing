import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta resumen del consumo total de almacenamiento y estado global del clúster de bases de datos.
// ignore: unintended_html_in_doc_comment
/// ¿De dónde recibe datos?: Recibe la lista completa de List<DatabaseInstance> para calcular totales acumulados.
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica en la parte superior de DatabasesPage (debajo del SectionHeader).
class DatabaseSummaryCard extends StatelessWidget {
  const DatabaseSummaryCard({
    required this.instances, // Lista completa de instancias de bases de datos
    super.key,
  });

  final List<DatabaseInstance> instances;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Cálculo acumulado del consumo global de almacenamiento y estado de instancias
    final double totalUsed = instances.fold(0.0, (sum, db) => sum + db.storageUsed);
    final double totalLimit = instances.fold(0.0, (sum, db) => sum + db.storageLimit);
    final int activeCount = instances.where((db) => db.isRunning).length;
    final int totalCount = instances.length;
    final double progress = totalLimit > 0 ? (totalUsed / totalLimit).clamp(0.0, 1.0) : 0.0;
    final int percentage = (progress * 100).toInt();

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 650;

          return Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              // Bloque 1: Consumo acumulado de almacenamiento con barra de progreso global
              Expanded(
                flex: isCompact ? 0 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.sd_storage_rounded,
                            color: theme.colorScheme.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consumo Total de Almacenamiento',
                              style: TextStyle(
                                color: subtitleColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${totalUsed.toInt()} MB / ${totalLimit.toInt()} MB ($percentage%)',
                              style: TextStyle(
                                color: titleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: theme.dividerColor.withValues(alpha: isDark ? 0.30 : 0.50),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 85
                              ? AppColors.error
                              : (percentage > 60 ? AppColors.warning : theme.colorScheme.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (!isCompact) ...[
                const SizedBox(width: 24),
                Container(
                  height: 54,
                  width: 1,
                  color: theme.dividerColor,
                ),
                const SizedBox(width: 24),
              ] else
                const SizedBox(height: 18),

              // Bloque 2: Resumen rápido de instancias activas y estado del clúster
              Expanded(
                flex: isCompact ? 0 : 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _SummaryMetricTile(
                      label: 'Instancias Activas',
                      value: '$activeCount / $totalCount',
                      icon: Icons.power_settings_new_rounded,
                      iconColor: AppColors.success,
                    ),
                    _SummaryMetricTile(
                      label: 'Estado del Clúster',
                      value: activeCount == totalCount ? 'Óptimo' : 'Parcial',
                      icon: Icons.health_and_safety_rounded,
                      iconColor: activeCount == totalCount ? AppColors.success : AppColors.warning,
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

/// Sub-widget privado para mostrar métricas individuales en el resumen
class _SummaryMetricTile extends StatelessWidget {
  const _SummaryMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: subtitleColor, fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
