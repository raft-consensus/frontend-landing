// ==========================================
// Qué hace: Vista principal del panel de Resumen (Overview) desacoplada y modularizada.
// De dónde trae datos: Escucha userDatabasesProvider, userAiProvider, userN8nProvider y userDnsProvider via Riverpod.
// Dónde se conecta: Primera pestaña (índice 0) de DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_n8n_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/activity_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/ecosystem_services.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/overview_databases_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/overview_metrics_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/welcome_banner.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({
    required this.onCreateDatabase,
    required this.onGoDatabases,
    required this.onGoDocumentation,
    this.onGoDns,
    this.onGoAi,
    this.onGoN8n,
    super.key,
  });

  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDatabases;
  final VoidCallback onGoDocumentation;
  final VoidCallback? onGoDns;
  final VoidCallback? onGoAi;
  final VoidCallback? onGoN8n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instances = ref.watch(userDatabasesProvider);
    final aiKeys = ref.watch(userAiProvider);
    final n8nData = ref.watch(userN8nProvider);
    final dnsRecords = ref.watch(userDnsProvider);

    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner principal de bienvenida
          WelcomeBanner(
            onCreateDatabase: onCreateDatabase,
            onGoDocumentation: onGoDocumentation,
          ),
          const SizedBox(height: 24),

          // 2. Componente modularizado de métricas (conteo total de BDs)
          OverviewMetricsGrid(
            totalDatabasesCount: instances.length, // 👈 Ahora cuenta TODAS las instancias (activas o detenidas)
            dnsSubdomainsCount: dnsRecords.length,
            aiKeysCount: aiKeys.length,
            n8nWorkflowsCount: n8nData?.activeWorkflows ?? 0,
          ),
          const SizedBox(height: 28),

          // 3. Fila Doble Responsiva: Ecosistema de Servicios + Actividad Reciente
          if (isDesktop)
            Row(
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
                const Expanded(flex: 2, child: ActivitySection()),
              ],
            )
          else ...[
            EcosystemServicesCard(
              onGoDns: onGoDns,
              onGoAi: onGoAi,
              onGoN8n: onGoN8n,
            ),
            const SizedBox(height: 20),
            const ActivitySection(),
          ],
          const SizedBox(height: 28),

          // 4. Encabezado de la sección de Instancias
          SectionHeader(
            title: 'Instancias de Bases de Datos',
            subtitle: 'Acceso rápido a tus instancias principales',
            actionLabel: 'Ver todas',
            onAction: onGoDatabases,
          ),
          const SizedBox(height: 14),

          // 5. Componente modularizado de lista/cuadrícula de instancias de BD
          OverviewDatabasesGrid(
            instances: instances,
            onGoDatabases: onGoDatabases,
            onCreateDatabase: onCreateDatabase,
          ),
        ],
      ),
    );
  }
}
