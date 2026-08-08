import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Fila individual para renderizar una notificación del sistema con viñeta coloreada.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de NotificationsDialog para listar los mensajes.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.color,       // Color de la viñeta (Verde = éxito, Azul = info, Naranja = alerta)
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
