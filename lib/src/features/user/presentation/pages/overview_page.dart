// ==========================================
// Archivo: lib/src/features/user/presentation/pages/overview_page.dart
// ¿Qué hace?: Vista principal del panel de Resumen (Overview) desacoplada y modularizada.
// ¿De dónde trae datos?: Escucha userDatabasesProvider, userAiProvider, userN8nProvider y userDnsProvider via Riverpod.
// ¿Hacia dónde va / Cómo se conecta?: Primera pestaña (índice 0) de DashboardPage, ensambla componentes independientes de overview/.
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
    required this.onCreateDatabase,   // Callback para abrir el modal de creación de BD
    required this.onGoDatabases,      // Callback para redirigir a la pestaña de Bases de Datos (índice 1)
    required this.onGoDocumentation,  // Callback para redirigir a la pestaña de Herramientas/Guías (índice 5)
    this.onGoDns,                     // Callback opcional para ir a DNS & SSL (índice 2)
    this.onGoAi,                      // Callback opcional para ir a Servicios de IA (índice 3)
    this.onGoN8n,                     // Callback opcional para ir a N8N Workflows (índice 4)
    super.key,
  });

  final VoidCallback onCreateDatabase;  // Función para abrir modal de creación
  final VoidCallback onGoDatabases;     // Función para navegar a bases de datos
  final VoidCallback onGoDocumentation; // Función para navegar a la documentación
  final VoidCallback? onGoDns;          // Función para navegar a DNS
  final VoidCallback? onGoAi;           // Función para navegar a IA
  final VoidCallback? onGoN8n;          // Función para navegar a N8N

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Escucha los proveedores de estado reactivos de Riverpod
    final instances = ref.watch(userDatabasesProvider); // Lista reactiva de bases de datos del usuario
    final aiKeys = ref.watch(userAiProvider);            // Lista reactiva de API Keys de IA
    final n8nData = ref.watch(userN8nProvider);          // Estado reactivo del servicio de n8n Workflows
    final dnsRecords = ref.watch(userDnsProvider);       // Lista reactiva de registros DNS del usuario

    // 2. Detecta si la pantalla es de escritorio (ancho >= 900px)
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

          // 2. Componente modularizado de métricas en cuadrícula
          OverviewMetricsGrid(
            runningDatabasesCount: instances.where((i) => i.isRunning).length,
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
