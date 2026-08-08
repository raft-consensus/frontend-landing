import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/hub_actions_helper.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/hub_service_tile.dart';

/// ¿Qué hace?: Renderiza la lista scrolleable de las 4 tarjetas de servicio con sus botones de atajo y navegación.
/// ¿De dónde trae datos?: Ingesta onSelectTab y onMessage, e interactúa con HubActionsHelper.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza dentro del modal ServicesHubDialog.
class HubServicesList extends ConsumerWidget {
  final ValueChanged<int>? onSelectTab;                                           // Callback para cambiar pestaña en sidebar
  final void Function(String message, {bool success})? onMessage;                 // Callback para notificaciones SnackBar

  const HubServicesList({
    this.onSelectTab,
    this.onMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context); // Tema activo

    return SingleChildScrollView(
      child: Column(
        children: [
          // 1. Servicio 1: Bases de Datos Distribuidas
          HubServiceTile(
            title: 'Bases de Datos Distribuidas',
            subtitle: 'Aprovisionar PostgreSQL, MySQL, SQL Server o MongoDB al instante.',
            icon: Icons.dns_rounded,
            color: theme.colorScheme.primary,
            status: 'Activo',
            actionLabel: '+ Nueva BD',
            actionIcon: Icons.add_rounded,
            onAction: () => HubActionsHelper.createDatabaseDirectly(
              context: context,
              ref: ref,
              onMessage: onMessage,
            ),
            onNavigate: () {
              Navigator.pop(context);
              onSelectTab?.call(1); // Navega a Bases de Datos (índice 1)
            },
          ),
          const SizedBox(height: 10),

          // 2. Servicio 2: Dominio, Red & SSL (DNS)
          HubServiceTile(
            title: 'Dominio, Red & SSL (DNS)',
            subtitle: 'Configuración e inserción de subdominios con certificados SSL.',
            icon: Icons.language_rounded,
            color: AppColors.cyan,
            status: 'Activo',
            actionLabel: '+ Crear DNS',
            actionIcon: Icons.add_link_rounded,
            onAction: () => HubActionsHelper.createDnsDirectly(
              context: context,
              ref: ref,
              onMessage: onMessage,
            ),
            onNavigate: () {
              Navigator.pop(context);
              onSelectTab?.call(2); // Navega a Dominio & SSL (índice 2)
            },
          ),
          const SizedBox(height: 10),

          // 3. Servicio 3: Servicios de Inteligencia Artificial
          HubServiceTile(
            title: 'Servicios de Inteligencia Artificial',
            subtitle: 'Generación directa de API Keys y consumo de modelos de IA.',
            icon: Icons.auto_awesome_rounded,
            color: AppColors.purple,
            status: 'Activo',
            actionLabel: '+ Crear Key IA',
            actionIcon: Icons.key_rounded,
            onAction: () => HubActionsHelper.createAiKeyDirectly(
              context: context,
              ref: ref,
              onMessage: onMessage,
            ),
            onNavigate: () {
              Navigator.pop(context);
              onSelectTab?.call(3); // Navega a Servicio de IA (índice 3)
            },
          ),
          const SizedBox(height: 10),

          // 4. Servicio 4: Automatización N8N Workflows
          HubServiceTile(
            title: 'Automatización & Workflows (n8n)',
            subtitle: 'Orquestación de flujos de trabajo e integración de Webhooks.',
            icon: Icons.hub_rounded,
            color: AppColors.success,
            status: 'Activo',
            actionLabel: 'Ir al Servicio n8n',
            actionIcon: Icons.launch_rounded,
            onAction: () {
              Navigator.pop(context);
              onSelectTab?.call(4); // Navega a la pestaña de n8n (índice 4)
            },
            onNavigate: () {
              Navigator.pop(context);
              onSelectTab?.call(4); // Navega a la pestaña de n8n (índice 4)
            },
          ),
        ],
      ),
    );
  }
}
