// ==========================================
// Qué hace: Tarjeta visual desacoplada con indicador de consumo de almacenamiento del Plan Estudiante.
// Dónde se conecta: Renderizado en el cuerpo medio de DashboardSidebar.
// De dónde trae datos: Se adapta dinámicamente al tema activo.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Tarjeta informativa de cuota de recursos del usuario
class SidebarStudentPlanCard extends StatelessWidget {
  const SidebarStudentPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark
        ? AppColors.nightCard.withValues(alpha: 0.6)
        : const Color(0xFFF0F7FF);
    final borderColor = isDark ? AppColors.nightBorder : const Color(0xFFD4E8FC);
    final primaryTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary;
    final secondaryTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final progressColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final progressBgColor = isDark ? const Color(0xFF28465F) : const Color(0xFFD4E8FC);

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Icono + Nombre del Plan
          Row(
            children: [
              Icon(
                Icons.school_outlined,
                size: 16,
                color: progressColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Plan Estudiante',
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Texto de consumo
          Text(
            'Uso de recursos: 326 MB / 512 MB',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),

          // Barra gráfica de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.63, // 63% consumido
              backgroundColor: progressBgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
