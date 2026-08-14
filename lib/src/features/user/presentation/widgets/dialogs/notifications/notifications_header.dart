// ==========================================
// Que hace: Encabezado del modal de notificaciones con icono, badge de no leidas y boton cerrar 'X'.
// De donde trae datos: Recibe unreadCount y el callback onClose.
// Donde se conecta: Consumido en la parte superior de NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Encabezado modular del modal de notificaciones
class NotificationsHeader extends StatelessWidget {
  const NotificationsHeader({
    required this.unreadCount, // Cantidad de notificaciones no leidas
    required this.onClose, // Callback al presionar cerrar
    super.key,
  });

  final int unreadCount;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final primaryAccent = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    return Row(
      children: [
        Icon(
          Icons.notifications_rounded,
          color: primaryAccent,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          'Notificaciones',
          style: TextStyle(
            color: titleColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (unreadCount > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: primaryAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$unreadCount nuevas',
              style: TextStyle(
                color: primaryAccent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
        const Spacer(),
        IconButton(
          onPressed: onClose,
          icon: Icon(
            Icons.close_rounded,
            color: titleColor.withValues(alpha: 0.6),
            size: 18,
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          splashRadius: 18,
          tooltip: 'Cerrar',
        ),
      ],
    );
  }
}
