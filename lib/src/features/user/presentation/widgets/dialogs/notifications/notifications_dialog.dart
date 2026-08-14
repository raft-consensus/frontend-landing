// ==========================================
// Que hace: Ensamblador limpio del modal de notificaciones que une header, lista/empty state y footer.
// De donde trae datos: Escucha userNotificationsProvider de Riverpod.
// Donde se conecta: Se abre desde la campana de DashboardTopbar.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_notifications_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notifications_empty_state.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notifications_footer.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notifications_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notifications_list.dart';

/// Modal modular interactivo de notificaciones
class NotificationsDialog extends ConsumerWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(userNotificationsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dialogBg = isDark ? AppColors.nightSurface : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final unreadCount = notifications.where((n) => !n.isRead).length;

    return Dialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor),
      ),
      child: Container(
        width: 440,
        constraints: const BoxConstraints(maxHeight: 520),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Encabezado modular
            NotificationsHeader(
              unreadCount: unreadCount,
              onClose: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 14),

            // 2. Cuerpo: Lista scrolleable o Estado Vacio
            Expanded(
              child: notifications.isEmpty
                  ? const NotificationsEmptyState()
                  : NotificationsList(notifications: notifications),
            ),
            const SizedBox(height: 10),
            Divider(color: borderColor, height: 1),
            const SizedBox(height: 10),

            // 3. Pie de acciones modular
            NotificationsFooter(
              unreadCount: unreadCount,
              onMarkAllAsRead: () {
                ref.read(userNotificationsProvider.notifier).markAllAsRead();
              },
              onDismiss: () {
                ref.read(userNotificationsProvider.notifier).markAllAsRead();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
