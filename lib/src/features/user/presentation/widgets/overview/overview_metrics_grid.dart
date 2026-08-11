// ==========================================
// Qué hace: Renderiza la cuadrícula responsiva de 4 tarjetas informativas de métricas (BDs totales, DNS, IA, N8N).
// Dónde se conecta: Se incluye en OverviewPage debajo del WelcomeBanner.
// De dónde trae datos: Ingesta los conteos numéricos de BDs totales, subdominios DNS, API Keys de IA y flujos N8N.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/metric_card.dart';

class OverviewMetricsGrid extends StatelessWidget {
  const OverviewMetricsGrid({
    required this.totalDatabasesCount, // Conteo total de todas las BDs (activas y detenidas)
    required this.dnsSubdomainsCount,
    required this.aiKeysCount,
    required this.n8nWorkflowsCount,
    super.key,
  });

  final int totalDatabasesCount; // Conteo real de BDs totales en el clúster
  final int dnsSubdomainsCount;    // Conteo real de registros/subdominios DNS
  final int aiKeysCount;          // Conteo real de API Keys de IA creadas
  final int n8nWorkflowsCount;    // Conteo real de flujos n8n activos

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
            // 1. Tarjeta BDs: Conteo total de bases de datos creadas
            SizedBox(
              width: itemWidth,
              child: MetricCard(
                title: 'Bases de Datos',
                value: '$totalDatabasesCount',
                subtitle: 'Instancias en tu clúster',
                icon: Icons.storage_rounded,
              ),
            ),

            // 2. Tarjeta DNS: Conteo real de subdominios/registros DNS
            SizedBox(
              width: itemWidth,
              child: MetricCard(
                title: 'Subdominios DNS',
                value: '$dnsSubdomainsCount',
                subtitle: 'Zonas DNS asignadas',
                icon: Icons.language_rounded,
              ),
            ),

            // 3. Tarjeta IA: Conteo real de claves de API
            SizedBox(
              width: itemWidth,
              child: MetricCard(
                title: 'AI Api Keys',
                value: '$aiKeysCount',
                subtitle: 'API Keys generadas',
                icon: Icons.auto_awesome_rounded,
              ),
            ),

            // 4. Tarjeta N8N: Conteo real de flujos n8n activos
            SizedBox(
              width: itemWidth,
              child: MetricCard(
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
