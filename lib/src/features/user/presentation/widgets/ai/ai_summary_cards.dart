// ==========================================
// Qué hace: Muestra las 3 tarjetas de métricas KPI del servicio de IA (Keys activas, peticiones y tokens).
// Dónde se conecta: Se renderiza en la parte superior de AiServicesPage.
// De dónde trae datos: Recibe activeKeysCount, totalRequests y totalTokens.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_metric_card.dart'; // AI Widgets

/// Tarjetas KPI del resumen global de IA compuestas por subwidgets desacoplados
class AiSummaryCards extends StatelessWidget {
  const AiSummaryCards({
    required this.activeKeysCount, // Total de claves activas
    required this.totalRequests,   // Total acumulado de peticiones
    required this.totalTokens,     // Total acumulado de tokens consumidos
    super.key,
  });

  final int activeKeysCount;
  final int totalRequests;
  final int totalTokens;

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
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                title: 'API Keys Activas',
                value: '$activeKeysCount / 10 Claves',
                subtitle: 'Límite máximo por usuario',
                icon: Icons.vpn_key_rounded,
                iconColor: isDark ? AppColors.purple : AppColors.dayPrimary,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                title: 'Consultas Totales',
                value: '$totalRequests reqs',
                subtitle: 'Solicitudes procesadas por la IA',
                icon: Icons.data_usage_rounded,
                iconColor: AppColors.info,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                title: 'Tokens Consumidos',
                value: '$totalTokens tokens',
                subtitle: 'Entrada y salida acumulada',
                icon: Icons.auto_awesome_rounded,
                iconColor: AppColors.success,
              ),
            ),
          ],
        );
      },
    );
  }
}
