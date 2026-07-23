import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Widget que muestra el registro cronológico de actividad reciente del usuario.
/// ¿De dónde trae?: Trae AppColors (core) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica en el panel lateral de OverviewPage.
class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividad Reciente',
            style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          _buildActivityItem('BD Creada', 'Creaste la instancia "proyecto-universidad"', 'Hace 10 min', Icons.add_circle_outline_rounded, AppColors.green),
          const Divider(height: 20),
          _buildActivityItem('Credenciales Consultadas', 'Consultaste credenciales de "api-tienda-demo"', 'Hace 1 hora', Icons.key_outlined, AppColors.blue),
          const Divider(height: 20),
          _buildActivityItem('Instancia Detenida', 'Detuviste la instancia "practica-consultas"', 'Ayer', Icons.pause_circle_outline_rounded, AppColors.orange),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String desc, String time, IconData icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 12)),
              Text(desc, style: const TextStyle(color: AppColors.muted, fontSize: 11)),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(color: AppColors.muted, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
