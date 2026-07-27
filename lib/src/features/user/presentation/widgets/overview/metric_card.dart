import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta gráfica para mostrar indicadores clave (Instancias activas, Almacenamiento, Consultas).
/// ¿De dónde trae?: Trae AppColors (core) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la cuadrícula de métricas de OverviewPage.
class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.title,      // Nombre del indicador (ej. "Instancias activas")
    required this.value,      // Valor destacado (ej. "3 / 5")
    required this.subtitle,   // Detalle adicional (ej. "2 PostgreSQL, 1 MongoDB")
    required this.icon,       // Icono característico
    required this.color,      // Color temático del indicador
    super.key,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Usa el widget envoltorio común DashboardCard
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Caja con icono del indicador
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              const Icon(Icons.arrow_upward_rounded, size: 14, color: AppColors.green),
            ],
          ),
          const SizedBox(height: 16),
          // Valor numérico grande
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          // Título de la métrica
          Text(
            title,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
