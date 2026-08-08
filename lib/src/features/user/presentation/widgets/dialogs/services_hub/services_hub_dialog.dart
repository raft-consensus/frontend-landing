import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/hub_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/hub_services_list.dart';

/// ¿Qué hace?: Modal contenedor ultra-liviano del Ecosistema Raft Hub que orquesta el encabezado y la lista de atajos.
/// ¿De dónde trae datos?: Ingesta callbacks para selección de pestaña y mensajes flotantes.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado desde el botón "Ecosistema Raft" en DashboardTopbar.
class ServicesHubDialog extends StatelessWidget {
  final VoidCallback onCreateDatabase;           // Callback de respaldo para compatibilidad
  final ValueChanged<int>? onSelectTab;           // Callback para cambiar la pestaña activa en el sidebar
  final void Function(String message, {bool success})? onMessage; // Callback para notificaciones flotantes SnackBar

  const ServicesHubDialog({
    required this.onCreateDatabase,
    this.onSelectTab,
    this.onMessage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema activo

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Encabezado del Modal (HubHeader)
              const HubHeader(),
              const SizedBox(height: 18),

              // 2. Lista Modularizada de Atajos de Servicios (HubServicesList)
              Flexible(
                child: HubServicesList(
                  onSelectTab: onSelectTab,
                  onMessage: onMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
