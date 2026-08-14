// ==========================================
// Qué hace: Cuadrícula responsiva que organiza las 3 tarjetas de métricas KPI superiores.
// Dónde se conecta: Renderizado en la parte superior de AiServicesPage.
// De dónde trae datos: Recibe activeKeysCount, totalRequests y totalTokens desde AiServicesPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/summary/ai_metric_card.dart';

/// Cuadrícula responsiva de tarjetas KPI de métricas de IA
class AiSummaryCards extends StatelessWidget {
  const AiSummaryCards({
    required this.activeKeysCount, // Total de claves activas
    required this.totalRequests,   // Total acumulado de peticiones procesadas
    required this.totalTokens,     // Total acumulado de tokens consumidos
    super.key,
  });

  final int activeKeysCount; // Conteo de claves activas
  final int totalRequests; // Conteo de peticiones
  final int totalTokens; // Conteo de tokens

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
            // 1. Tarjeta Claves Activas sobre 10
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                value: '$activeKeysCount / 10 Claves',
                title: 'API Keys Activas',
                icon: Icons.vpn_key_rounded,
                iconColor: isDark ? AppColors.purple : AppColors.dayPrimary,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 2. Tarjeta Consultas Totales
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                value: '$totalRequests reqs',
                title: 'Consultas Totales',
                icon: Icons.data_usage_rounded,
                iconColor: AppColors.info,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 3. Tarjeta Tokens Consumidos
            Expanded(
              flex: isWide ? 1 : 0,
              child: AiMetricCard(
                value: '$totalTokens tokens',
                title: 'Tokens Consumidos',
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
