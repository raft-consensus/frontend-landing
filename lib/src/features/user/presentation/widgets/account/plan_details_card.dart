import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta lateral informativa con el estado del plan actual "Plan Estudiante" y cuotas de uso.
/// ¿De dónde trae?: Trae AppColors (core) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se coloca en la columna lateral de AccountPage.
class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppColors.blue, size: 24),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Plan Estudiante', style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900)),
                    Text('Plan Gratuito Activo', style: TextStyle(color: AppColors.green, fontSize: 11, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          _buildQuotaRow('Instancias de BD', '3 de 5 creadas'),
          const SizedBox(height: 10),
          _buildQuotaRow('Almacenamiento total', '326 MB / 512 MB'),
          const SizedBox(height: 10),
          _buildQuotaRow('Soporte', 'Comunidad & Guías'),
          const SizedBox(height: 22),

          // Botón para mejorar plan
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onMessage('Solicitud de upgrade enviada.'),
              icon: const Icon(Icons.rocket_launch_rounded, size: 16),
              label: const Text('Mejorar a Plan Pro'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.navy,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
        Text(value, style: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }
}
