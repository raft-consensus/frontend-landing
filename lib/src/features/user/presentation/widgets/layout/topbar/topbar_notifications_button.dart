// ==========================================
// Qué hace: Botón de campana de notificaciones con badge contador reactivo de eventos sin leer.
// Dónde se conecta: Consumido por DashboardTopbar.
// De dónde trae datos: Escucha unreadNotificationsCountProvider y abre NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_notifications_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications/notifications_dialog.dart';

/// Botón con badge indicador de notificaciones
class TopbarNotificationsButton extends ConsumerWidget {
  const TopbarNotificationsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unreadCount = ref.watch(unreadNotificationsCountProvider);

    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const NotificationsDialog(),
            );
          },
          icon: Icon(Icons.notifications_none_rounded, color: iconColor),
          tooltip: 'Notificaciones del sistema',
        ),
        if (unreadCount > 0)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
