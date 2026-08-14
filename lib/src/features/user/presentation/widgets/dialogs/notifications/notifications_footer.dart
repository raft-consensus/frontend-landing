// ==========================================
// Que hace: Barra inferior de acciones del modal de notificaciones (Marcar leidas y Entendido).
// De donde trae datos: Recibe unreadCount, onMarkAllAsRead y onDismiss.
// Donde se conecta: Consumido al pie de NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Pie de acciones del modal de notificaciones
class NotificationsFooter extends StatelessWidget {
  const NotificationsFooter({
    required this.unreadCount, // Cantidad de no leidas para mostrar u ocultar boton
    required this.onMarkAllAsRead, // Callback para marcar leidas
    required this.onDismiss, // Callback para cerrar el modal
    super.key,
  });

  final int unreadCount;
  final VoidCallback onMarkAllAsRead;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final primaryAccent = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (unreadCount > 0)
          TextButton(
            onPressed: onMarkAllAsRead,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            ),
            child: Text(
              'Marcar todas como leídas',
              style: TextStyle(
                color: primaryAccent,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          const SizedBox.shrink(),
        TextButton(
          onPressed: onDismiss,
          child: Text(
            'Entendido',
            style: TextStyle(
              color: titleColor,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
