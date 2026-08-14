// ==========================================
// Que hace: Lista scrolleable que mapea las entidades UserNotification a tarjetas NotificationItem.
// De donde trae datos: Recibe la lista notifications desde NotificationsDialog.
// Donde se conecta: Consumido dentro del cuerpo de NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/user_notification.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notification_item.dart';

/// Lista scrolleable de notificaciones del sistema
class NotificationsList extends StatelessWidget {
  const NotificationsList({
    required this.notifications, // Lista inmutable de notificaciones
    super.key,
  });

  final List<UserNotification> notifications;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];
        return NotificationItem(
          color: notif.color,
          title: notif.title,
          description: notif.description,
          time: notif.time,
          isRead: notif.isRead,
        );
      },
    );
  }
}
