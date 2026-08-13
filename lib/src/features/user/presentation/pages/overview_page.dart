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

/// Clase principal que representa la vista general del usuario en la plataforma
class OverviewPage extends ConsumerWidget {
  /// Constructor del componente OverviewPage
  const OverviewPage({
    required this.onCreateDatabase, // Callback al presionar el botón de crear BD
    required this.onGoDatabases,   // Callback para navegar a la pestaña de BD
    required this.onGoDocumentation,// Callback para ir a la documentación
    this.onGoDns,                  // Callback opcional para ir a la pestaña DNS
    this.onGoAi,                   // Callback opcional para ir a la pestaña IA
    this.onGoN8n,                  // Callback opcional para ir a la pestaña N8N
    super.key,
  });

  final VoidCallback onCreateDatabase; // Atributo: Acción al solicitar nueva base de datos
  final VoidCallback onGoDatabases;   // Atributo: Acción al solicitar ver todas las bases de datos
  final VoidCallback onGoDocumentation; // Atributo: Acción al abrir la guía de conexión/docs
  final VoidCallback? onGoDns;        // Atributo: Acción opcional al presionar DNS
  final VoidCallback? onGoAi;         // Atributo: Acción opcional al presionar IA
  final VoidCallback? onGoN8n;        // Atributo: Acción opcional al presionar N8N

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Método principal de construcción UI
    final instances = ref.watch(userDatabasesProvider); // Obtiene lista de instancias de BD del usuario
    final aiKeys = ref.watch(userAiProvider); // Obtiene llaves de IA activas
    final n8nData = ref.watch(userN8nProvider); // Obtiene información del servicio N8N
    final dnsRecords = ref.watch(userDnsProvider); // Obtiene registros DNS asignados

    final isDesktop = MediaQuery.of(context).size.width >= 1000; // Evalúa si la pantalla es de tamaño escritorio

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
            totalDatabasesCount: instances.length, // Cuenta todas las instancias activas o inactivas
            dnsSubdomainsCount: dnsRecords.length,
            aiKeysCount: aiKeys.length,
            n8nWorkflowsCount: n8nData?.activeWorkflows ?? 0,
          ),
          const SizedBox(height: 28),

          // 3. Fila Doble Responsiva: Ecosistema de Servicios + Actividad Reciente (Se eliminó IntrinsicHeight para solucionar el fallo en web)
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
                const Expanded(
                  flex: 2,
                  child: ActivitySection(),
                ),
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
