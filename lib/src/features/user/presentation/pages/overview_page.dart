// ==========================================
// Qué hace: Vista principal del panel de Resumen (Overview) orquestando únicamente los 4 macro-widgets.
// De dónde trae datos: Sintoniza proveedores de Riverpod (Databases, AI, N8N, DNS) y recibe callbacks de navegación.
// Dónde se conecta: Pestaña índice 0 en DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_n8n_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/banner/welcome_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/databases/overview_databases_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/metrics/overview_metrics_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/services/services_activity_section.dart';

/// Vista principal de Resumen (Overview) del panel de usuario
class OverviewPage extends ConsumerWidget {
  const OverviewPage({
    required this.onCreateDatabase, // Callback crear BD
    required this.onGoDatabases, // Callback ir a Bases de datos
    required this.onGoDocumentation, // Callback ir a Documentación
    this.onGoDns, // Callback ir a DNS
    this.onGoAi, // Callback ir a IA
    this.onGoN8n, // Callback ir a N8N
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
    // 1. Sintonización reactiva de los proveedores del dashboard
    final instances = ref.watch(userDatabasesProvider);
    final aiKeys = ref.watch(userAiProvider);
    final n8nData = ref.watch(userN8nProvider);
    final dnsRecords = ref.watch(userDnsProvider);

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Macro-Sección 1: Banner de Bienvenida
          WelcomeBanner(
            onCreateDatabase: onCreateDatabase,
            onGoDocumentation: onGoDocumentation,
          ),
          const SizedBox(height: 24),

          // 2. Macro-Sección 2: Cuadrícula de Métricas KPI
          OverviewMetricsGrid(
            totalDatabasesCount: instances.length,
            dnsSubdomainsCount: dnsRecords.length,
            aiKeysCount: aiKeys.length,
            n8nWorkflowsCount: n8nData?.activeWorkflows ?? 0,
          ),
          const SizedBox(height: 28),

          // 3. Macro-Sección 3: Ecosistema de Servicios y Actividad Reciente
          ServicesActivitySection(
            onGoDns: onGoDns,
            onGoAi: onGoAi,
            onGoN8n: onGoN8n,
          ),
          const SizedBox(height: 28),

          // 4. Macro-Sección 4: Instancias de Bases de Datos
          OverviewDatabasesSection(
            instances: instances,
            onGoDatabases: onGoDatabases,
            onCreateDatabase: onCreateDatabase,
          ),
        ],
      ),
    );
  }
}
