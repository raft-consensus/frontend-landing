// ==========================================
// Qué hace: Macro-sección responsiva que agrupa el Ecosistema de Servicios y la Actividad Reciente.
// Dónde se conecta: Consumido por OverviewPage.
// De dónde trae datos: Recibe callbacks onGoDns, onGoAi y onGoN8n, y adapta el layout (Fila en PC, Columna en Móvil).
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/services/activity_section_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/services/ecosystem_services_card.dart';

/// Sección responsiva de Ecosistema de Servicios y Actividad Reciente
class ServicesActivitySection extends StatelessWidget {
  const ServicesActivitySection({
    this.onGoDns, // Callback opcional a DNS
    this.onGoAi, // Callback opcional a IA
    this.onGoN8n, // Callback opcional a N8N
    super.key,
  });

  final VoidCallback? onGoDns;
  final VoidCallback? onGoAi;
  final VoidCallback? onGoN8n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 736;

        // 1. Vista Escritorio: Fila proporcional (Flex 3 para servicios, Flex 2 para actividad)
        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: EcosystemServicesCard(
                  onGoDns: onGoDns,
                  onGoAi: onGoAi,
                  onGoN8n: onGoN8n,
                ),
              ),
              const SizedBox(width: 20),
              const Expanded(
                flex: 2,
                child: ActivitySectionCard(),
              ),
            ],
          );
        }

        // 2. Vista Móvil / Tablet: Columna vertical
        return Column(
          children: [
            EcosystemServicesCard(
              onGoDns: onGoDns,
              onGoAi: onGoAi,
              onGoN8n: onGoN8n,
            ),
            const SizedBox(height: 20),
            const ActivitySectionCard(),
          ],
        );
      },
    );
  }
}
