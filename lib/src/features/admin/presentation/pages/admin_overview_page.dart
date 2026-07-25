import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart'; // Domain
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/overview/admin_welcome_banner.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/overview/admin_metric_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/overview/platform_activity_chart.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/overview/engine_distribution_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/overview/service_status_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/audit/audit_event_row.dart'; // Widget

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({
    required this.users,
    required this.databases,
    required this.events,
    required this.maintenanceMode,
    required this.onNavigate,
    required this.onMessage,
    super.key,
  });

  final List<PlatformUser> users;
  final List<ManagedDatabase> databases;
  final List<AuditEvent> events;
  final bool maintenanceMode;
  final ValueChanged<int> onNavigate;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final activeUsers = users.where((user) => !user.suspended).length;
    final activeDatabases =
        databases.where((database) => database.running).length;
    final totalStorage = databases.fold<double>(
      0,
      (total, database) => total + database.storageMb,
    );

    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminWelcomeBanner(
            maintenanceMode: maintenanceMode,
            onMessage: onMessage,
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1100
                  ? (width - 54) / 4
                  : width >= 620
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.people_alt_rounded,
                    color: AppColors.blue,
                    value: '${users.length}',
                    label: 'Usuarios registrados',
                    detail: '$activeUsers cuentas activas',
                    trend: '+12% este mes',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.storage_rounded,
                    color: AppColors.green,
                    value: '${databases.length}',
                    label: 'Instancias totales',
                    detail: '$activeDatabases en ejecución',
                    trend: '+8% este mes',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.data_usage_rounded,
                    color: AppColors.purple,
                    value: '${totalStorage.toStringAsFixed(0)} MB',
                    label: 'Almacenamiento',
                    detail: 'Uso global de la plataforma',
                    trend: '32% disponible',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.monitor_heart_rounded,
                    color: AppColors.orange,
                    value: '99.98%',
                    label: 'Disponibilidad',
                    detail: 'Últimos 30 días',
                    trend: 'Operación estable',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              if (!desktop) {
                return Column(
                  children: [
                    const PlatformActivityChart(),
                    const SizedBox(height: 18),
                    EngineDistributionCard(databases: databases),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: PlatformActivityChart(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: EngineDistributionCard(
                      databases: databases,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 25),
          SectionTitle(
            title: 'Estado de infraestructura',
            subtitle: 'Vista rápida de los servicios principales.',
            action: 'Ver infraestructura',
            onAction: () => onNavigate(3),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width >= 900
                  ? (width - 36) / 3
                  : width >= 600
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: const [
                  ServiceStatusCard(
                    name: 'API principal',
                    detail: '38 ms de respuesta',
                    icon: Icons.api_rounded,
                    color: AppColors.blue,
                  ),
                  ServiceStatusCard(
                    name: 'Clúster de bases de datos',
                    detail: '5 nodos saludables',
                    icon: Icons.hub_rounded,
                    color: AppColors.green,
                  ),
                  ServiceStatusCard(
                    name: 'Autenticación',
                    detail: 'OAuth operativo',
                    icon: Icons.security_rounded,
                    color: AppColors.purple,
                  ),
                ]
                    .map(
                      (card) => SizedBox(
                        width: itemWidth,
                        child: card,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 25),
          SectionTitle(
            title: 'Eventos recientes',
            subtitle: 'Actividad administrativa y de seguridad.',
            action: 'Ver auditoría',
            onAction: () => onNavigate(4),
          ),
          const SizedBox(height: 14),
          AdminCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 6,
            ),
            child: Column(
              children: events
                  .take(4)
                  .map(
                    (event) => AuditEventRow(event: event),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
