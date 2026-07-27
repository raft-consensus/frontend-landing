import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/activity_section.dart'; // Overview
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/compact_database.dart' show CompactDatabaseCard;
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/metric_card.dart'; // Overview
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/usage_chart_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/welcome_banner.dart' show WelcomeBanner; // Overview

/// ¿Qué hace?: Página web principal del panel de Resumen (Overview) con métricas, gráficos y accesos rápidos.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), widgets de common y widgets de overview.
/// ¿Hacia dónde va / Cómo se conecta?: Es la primera pestaña renderizada dentro de DashboardPage.
class OverviewPage extends StatelessWidget {
  const OverviewPage({
    required this.instances,          // Lista de instancias de BD
    required this.onCreateDatabase,   // Callback para abrir el modal de crear BD
    required this.onGoDatabases,      // Callback para ir a la pestaña de BD
    required this.onGoDocumentation,  // Callback para ir a la pestaña de docs
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDatabases;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner principal de bienvenida
          WelcomeBanner(
            onCreateDatabase: onCreateDatabase,
            onGoDocumentation: onGoDocumentation,
          ),
          const SizedBox(height: 24),

          // Cuadrícula de 3 Métricas clave
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cols = width >= 900 ? 3 : (width >= 600 ? 2 : 1);

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  SizedBox(
                    width: (width - (cols - 1) * 16) / cols,
                    child: MetricCard(
                      title: 'Instancias Activas',
                      value: '${instances.where((i) => i.isRunning).length} / ${instances.length}',
                      subtitle: 'Bases de datos operativas',
                      icon: Icons.dns_rounded,
                      color: AppColors.blue,
                    ),
                  ),
                  SizedBox(
                    width: (width - (cols - 1) * 16) / cols,
                    child: const MetricCard(
                      title: 'Almacenamiento Usado',
                      value: '326 MB',
                      subtitle: 'De 512 MB asignados',
                      icon: Icons.storage_rounded,
                      color: AppColors.purple,
                    ),
                  ),
                  SizedBox(
                    width: (width - (cols - 1) * 16) / cols,
                    child: const MetricCard(
                      title: 'Consultas este mes',
                      value: '42.8k',
                      subtitle: 'Peticiones atendidas',
                      icon: Icons.speed_rounded,
                      color: AppColors.green,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 28),

          // Fila doble: Gráfico de actividad + Panel de actividad reciente
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 3, child: UsageChartCard()),
                const SizedBox(width: 20),
                const Expanded(flex: 2, child: ActivitySection()),
              ],
            )
          else ...[
            const UsageChartCard(),
            const SizedBox(height: 20),
            const ActivitySection(),
          ],
          const SizedBox(height: 28),

          // Sección de Instancias Rápidas
          SectionHeader(
            title: 'Tus Bases de Datos',
            subtitle: 'Acceso rápido a tus instancias de prueba',
            actionLabel: 'Ver todas',
            onAction: onGoDatabases,
          ),
          const SizedBox(height: 14),

          Column(
            children: instances
                .map((instance) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CompactDatabaseCard(
                        instance: instance,
                        onTap: onGoDatabases,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
