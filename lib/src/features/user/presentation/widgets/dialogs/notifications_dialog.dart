import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notification_item.dart'; // Dialogs

/// ¿Qué hace?: Modal que despliega la lista de notificaciones y alertas del sistema.
/// ¿De dónde trae?: Trae AppColors (core) y NotificationItem (presentation/widgets/dialogs).
/// ¿Hacia dónde va / Cómo se conecta?: Se abre desde el icono de campana en DashboardTopbar.
class NotificationsDialog extends StatelessWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 9),
          Text('Notificaciones'),
        ],
      ),
      content: const SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Items de notificación con NotificationItem (dialogs)
            NotificationItem(
              color: AppColors.green,
              title: 'Instancia disponible',
              description: 'api-tienda-demo está funcionando.',
              time: 'Hace 12 min',
            ),
            Divider(),
            NotificationItem(
              color: AppColors.blue,
              title: 'Nueva guía disponible',
              description: 'Aprende a conectar PostgreSQL con Flutter.',
              time: 'Hace 3 h',
            ),
            Divider(),
            NotificationItem(
              color: AppColors.orange,
              title: 'Mantenimiento programado',
              description: 'Domingo a las 02:00 UTC.',
              time: 'Ayer',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
