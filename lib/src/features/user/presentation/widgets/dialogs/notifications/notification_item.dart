// ==========================================
// Que hace: Tarjeta individual interactiva para renderizar una notificacion con viñeta de estado, contraste adaptativo y hora.
// De donde trae datos: Recibe color, title, description, time e isRead de cada UserNotification.
// Donde se conecta: Importado y listado dentro de NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Tarjeta individual para renderizar una notificacion del sistema con alto contraste
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.color, // Color de estado (Verde = exito, Azul = info, Rojo = alerta)
    required this.title, // Titulo de la notificacion
    required this.description, // Mensaje explicativo
    required this.time, // Tiempo transcurrido
    this.isRead = false, // Bandera de estado de lectura
    super.key,
  });

  final Color color; // Color del indicador
  final String title; // Titulo principal
  final String description; // Descripcion detallada
  final String time; // Momento del evento
  final bool isRead; // Si ya fue vista por el usuario

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final descColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final timeColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final cardBg = isDark
        ? (isRead ? AppColors.nightBackground.withValues(alpha: 0.4) : AppColors.nightBackground)
        : (isRead ? Colors.grey.shade50 : AppColors.dayBackground);
    final borderColor = isDark
        ? (isRead ? AppColors.nightBorder.withValues(alpha: 0.5) : AppColors.nightBorder)
        : (isRead ? AppColors.dayBorder.withValues(alpha: 0.6) : AppColors.dayBorder);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viñeta circular de estado con sombra de brillo
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Contenido textual con tipografía limpia y contrastada
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 13.5,
                    fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: TextStyle(
                    color: descColor,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: TextStyle(
                    color: timeColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
