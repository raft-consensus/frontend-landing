// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/dialogs/notifications/notification_item.dart
// Qué hace: Fila individual para renderizar una notificación del sistema con viñeta coloreada.
// Dónde se conecta: Importado por NotificationsDialog para listar cada mensaje.
// De dónde recibe datos: Recibe color, title, description y time de cada UserNotification.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Fila individual para renderizar una notificación del sistema con viñeta coloreada
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.color,       // Color de la viñeta (Verde = éxito, Azul = info, Rojo = alerta)
    required this.title,       // Título de la notificación
    required this.description, // Explicación del evento
    required this.time,        // Tiempo transcurrido (ej. "Hace 12 min")
    super.key,
  });

  final Color color;
  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Viñeta circular de color a la izquierda
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(radius: 5, backgroundColor: color),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
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
