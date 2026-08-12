import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/summary/n8n_metric_card_item.dart';

/// ¿Qué hace?: Widget gestor que organiza la disposición responsive en Flex de las 3 tarjetas KPI métricas de n8n.
/// ¿De dónde trae datos?: Ingesta estado de activación, recuento de flujos y consumos mensuales.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido en la zona superior de N8nServicesPage.
class N8nSummaryCards extends StatelessWidget {
  final bool isActivated;          // Estado de activación de la cuenta
  final String serviceStatus;      // Estado de conexión del servicio
  final int activeWorkflows;       // Total de flujos activos
  final int maxWorkflows;          // Límite de flujos
  final int monthlyExecutions;     // Consumo mensual
  final int maxMonthlyExecutions;  // Límite mensual

  const N8nSummaryCards({
    required this.isActivated,
    required this.serviceStatus,
    required this.activeWorkflows,
    required this.maxWorkflows,
    required this.monthlyExecutions,
    required this.maxMonthlyExecutions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 750;

        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            // 1. Tarjeta de Estado del Servicio
            Expanded(
              flex: isWide ? 1 : 0,
              child: N8nMetricCardItem(
                title: 'Estado del Servicio',
                value: isActivated ? 'Conectado' : 'Pendiente de Activación',
                subtitle: isActivated ? 'Célula n8n Externa' : 'Requiere vinculación',
                icon: isActivated ? Icons.hub_rounded : Icons.pause_circle_outline_rounded,
                iconColor: isActivated ? AppColors.success : AppColors.warning,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 2. Tarjeta de Flujos Activos
            Expanded(
              flex: isWide ? 1 : 0,
              child: N8nMetricCardItem(
                title: 'Flujos Activos',
                value: isActivated ? '$activeWorkflows / $maxWorkflows Flujos' : '0 / $maxWorkflows Flujos',
                subtitle: 'Cuota asignada por célula',
                icon: Icons.account_tree_rounded,
                iconColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 3. Tarjeta de Ejecuciones Mensuales
            Expanded(
              flex: isWide ? 1 : 0,
              child: N8nMetricCardItem(
                title: 'Ejecuciones del Mes',
                value: isActivated ? '$monthlyExecutions / $maxMonthlyExecutions' : '0 / $maxMonthlyExecutions',
                subtitle: 'Restablecimiento mensual',
                icon: Icons.speed_rounded,
                iconColor: AppColors.info,
              ),
            ),
          ],
        );
      },
    );
  }
}
