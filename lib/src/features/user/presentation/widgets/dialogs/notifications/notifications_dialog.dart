// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/dialogs/notifications_dialog.dart
// Qué hace: Modal que despliega la lista de notificaciones y alertas en tiempo real del usuario.
// Dónde se conecta: Consume userNotificationsProvider en Riverpod. Se abre desde la campana de DashboardTopbar.
// De dónde recibe datos: Escucha el estado global de notificaciones del usuario.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/providers/user_notifications_provider.dart'; // Providers
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notification_item.dart'; // Dialogs

/// Modal interactivo que muestra las notificaciones reales generadas por la plataforma
class NotificationsDialog extends ConsumerWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(userNotificationsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.notifications_none_rounded, color: theme.colorScheme.primary),
          const SizedBox(width: 9),
          Text(
            'Notificaciones',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                ref.read(userNotificationsProvider.notifier).markAllAsRead();
              },
              child: const Text('Marcar leídas', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: notifications.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: Text(
                    'No tienes notificaciones pendientes',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < notifications.length; i++) ...[
                      NotificationItem(
                        color: notifications[i].color,
                        title: notifications[i].title,
                        description: notifications[i].description,
                        time: notifications[i].time,
                      ),
                      if (i < notifications.length - 1) const Divider(),
                    ],
                  ],
                ),
              ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(userNotificationsProvider.notifier).markAllAsRead();
            Navigator.pop(context);
          },
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
