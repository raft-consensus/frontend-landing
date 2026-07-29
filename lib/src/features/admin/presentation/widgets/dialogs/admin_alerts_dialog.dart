import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class AdminAlertsDialog extends StatelessWidget {
  const AdminAlertsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 9),
          Text('Alertas administrativas'),
        ],
      ),
      content: const SizedBox(
        width: 430,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertItem(
              color: AppColors.red,
              title: 'Intentos de acceso sospechosos',
              description: '5 intentos desde la IP 45.73.12.91.',
            ),
            Divider(),
            AlertItem(
              color: AppColors.orange,
              title: 'Nodo con carga elevada',
              description: 'raft-node-03 alcanzó 78% de CPU.',
            ),
            Divider(),
            AlertItem(
              color: AppColors.blue,
              title: 'Nuevo usuario registrado',
              description: 'jose@instituto.edu creó una cuenta.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class AlertItem extends StatelessWidget {
  const AlertItem({
    required this.color,
    required this.title,
    required this.description,
    super.key,
  });

  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.10),
            child: Icon(
              Icons.notifications_active_outlined,
              color: color,
              size: 18,
            ),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
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
