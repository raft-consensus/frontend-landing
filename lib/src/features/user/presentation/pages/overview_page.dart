import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/activity_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/compact_database.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/ecosystem_services.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/metric_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/welcome_banner.dart';

/// ¿Qué hace?: Vista principal del panel de Resumen (Overview) con el banner, 4 tarjetas de los 4 servicios Raft e instancias.
/// ¿De dónde trae datos?: Ingesta la lista de instancias de DatabaseInstance y callbacks de navegación desde DashboardPage.
/// ¿Hacia dónde va / Cómo se conecta?: Es la primera pestaña renderizada dentro de DashboardPage.
class OverviewPage extends StatelessWidget {
  const OverviewPage({
    required this.instances, // Lista de instancias de BD del usuario
    required this.onCreateDatabase, // Callback para abrir el modal de creación de BD
    required this.onGoDatabases, // Callback para ir a la pestaña de BD
    required this.onGoDocumentation, // Callback para ir a la pestaña de documentación
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDatabases;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si la pantalla es de escritorio (>= 900px)
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Banner principal de bienvenida con balsa (WelcomeBanner)
          WelcomeBanner(
            onCreateDatabase: onCreateDatabase,
            onGoDocumentation: onGoDocumentation,
          ),
          const SizedBox(height: 24),

          // 2. Fila superior de 4 tarjetas informativas de los 4 servicios Raft
          _MetricsGrid(instances: instances),
          const SizedBox(height: 28),

          // 3. Fila Doble Responsiva: Ecosistema de Servicios Raft + Actividad Reciente (285px de alto)
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: EcosystemServicesCard(
                    onGoDns:
                        onGoDocumentation, // Redirige a la sección de DNS / Guías
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(flex: 2, child: ActivitySection()),
              ],
            )
          else ...[
            const EcosystemServicesCard(),
            const SizedBox(height: 20),
            const ActivitySection(),
          ],
          const SizedBox(height: 28),

          // 4. Encabezado de la sección de Instancias
          SectionHeader(
            title: 'Instancias de Bases de Datos',
            subtitle: 'Acceso rápido a tus instancias de prueba',
            actionLabel: 'Ver todas',
            onAction: onGoDatabases,
          ),
          const SizedBox(height: 14),

          // 5. Cuadrícula responsiva horizontal de máximo 4 tarjetas de BD
          _DatabasesGrid(instances: instances, onGoDatabases: onGoDatabases),
        ],
      ),
    );
  }
}

/// Sub-widget privado 1: Fila/Cuadrícula responsiva de 4 tarjetas informativas (Icono | Contador | Nombre)
class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.instances});

  final List<DatabaseInstance> instances;

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
            // 1. Servicio BDs: Icono | 5 | Bases de Datos
            SizedBox(
              width: itemWidth,
              child: MetricCard(
                title: 'Bases de Datos',
                value: '${instances.where((i) => i.isRunning).length}',
                subtitle: 'Bases de datos activas',
                icon: Icons.storage_rounded,
              ),
            ),

            // 2. Servicio DNS: Icono | 3 | Zonas DNS
            SizedBox(
              width: itemWidth,
              child: const MetricCard(
                title: 'Subdominos DNS',
                value: '3',
                subtitle: 'Zonas DNS asignadas',
                icon: Icons.language_rounded,
              ),
            ),

            // 3. Servicio IA: Icono | 1 | IA Keys
            SizedBox(
              width: itemWidth,
              child: const MetricCard(
                title: 'AI Api Keys',
                value: '1',
                subtitle: 'API Keys generadas',
                icon: Icons.auto_awesome_rounded,
              ),
            ),

            // 4. Servicio N8N: Icono | 1 | Instancia N8N
            SizedBox(
              width: itemWidth,
              child: const MetricCard(
                title: 'Flujos N8N',
                value: '1',
                subtitle: 'Acceso a flujos',
                icon: Icons.account_tree_rounded,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Sub-widget privado 2: Cuadrícula horizontal responsiva de máximo 4 Tarjetas de Bases de Datos
class _DatabasesGrid extends StatelessWidget {
  const _DatabasesGrid({required this.instances, required this.onGoDatabases});

  final List<DatabaseInstance> instances;
  final VoidCallback onGoDatabases;

  @override
  Widget build(BuildContext context) {
    final displayedInstances = instances.take(4).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cols = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
        final itemWidth = (width - (cols - 1) * 14) / cols;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: displayedInstances
              .map(
                (instance) => SizedBox(
                  width: itemWidth,
                  child: CompactDatabaseCard(
                    instance: instance,
                    onTap: onGoDatabases,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
