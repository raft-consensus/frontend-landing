// ==========================================
// Que hace: Renderiza una ilustracion limpia cuando no existen notificaciones en el sistema.
// De donde trae datos: Detecta el tema activo dia/noche.
// Donde se conecta: Consumido en NotificationsDialog si la lista esta vacia.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Estado vacio cuando no hay notificaciones
class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 42,
              color: mutedColor.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 12),
            Text(
              'No tienes notificaciones pendientes',
              style: TextStyle(
                color: mutedColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
