// ==========================================
// Qué hace: Renderiza la cuadrícula responsiva de 4 tarjetas de métricas (BDs, DNS, IA, N8N).
// Dónde se conecta: Se incluye en OverviewPage debajo de WelcomeBanner.
// De dónde trae datos: Recibe los conteos de BDs, DNS, IA y N8N.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/metrics/overview_metric_card.dart';

/// Cuadrícula responsiva que organiza las 4 métricas principales de la plataforma
class OverviewMetricsGrid extends StatelessWidget {
  const OverviewMetricsGrid({
    required this.totalDatabasesCount, // Conteo de BDs
    required this.dnsSubdomainsCount, // Conteo de DNS
    required this.aiKeysCount, // Conteo de IA
    required this.n8nWorkflowsCount, // Conteo de N8N
    super.key,
  });

  final int totalDatabasesCount;
  final int dnsSubdomainsCount;
  final int aiKeysCount;
  final int n8nWorkflowsCount;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cols = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
        final itemWidth = (width - (cols - 1) * 14) / cols;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            // 1. Tarjeta BDs
            SizedBox(
              width: itemWidth,
              child: OverviewMetricCard(
                title: 'Bases de Datos',
                value: '$totalDatabasesCount',
                subtitle: 'Instancias en tu clúster',
                icon: Icons.storage_rounded,
              ),
            ),

            // 2. Tarjeta DNS
            SizedBox(
              width: itemWidth,
              child: OverviewMetricCard(
                title: 'Subdominios DNS',
                value: '$dnsSubdomainsCount',
                subtitle: 'Zonas DNS asignadas',
                icon: Icons.language_rounded,
              ),
            ),

            // 3. Tarjeta IA
            SizedBox(
              width: itemWidth,
              child: OverviewMetricCard(
                title: 'AI Api Keys',
                value: '$aiKeysCount',
                subtitle: 'API Keys generadas',
                icon: Icons.auto_awesome_rounded,
              ),
            ),

            // 4. Tarjeta N8N
            SizedBox(
              width: itemWidth,
              child: OverviewMetricCard(
                title: 'Flujos N8N',
                value: '$n8nWorkflowsCount',
                subtitle: 'Acceso a flujos activos',
                icon: Icons.account_tree_rounded,
              ),
            ),
          ],
        );
      },
    );
  }
}
