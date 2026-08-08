import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';

/// ¿Qué hace?: Tarjeta individual con animación hover para presentar un indicador numérico de métrica.
/// ¿De dónde trae datos?: Ingesta IconData, String value, String label, Color y width desde MetricsGrid.
/// ¿Hacia dónde va / Cómo se conecta?: Utilizado dentro de MetricsGrid.
class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.icon, // Icono del servicio/métrica
    required this.value, // Valor numérico o porcentaje
    required this.label, // Etiqueta descriptiva
    required this.color, // Color característico del icono
    required this.width, // Ancho calculado dinámicamente
    super.key,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final double width;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface; // Fondo dinámico
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde dinámico
    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Texto valor
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Texto etiqueta

    return HoverCard(
      borderRadius: 16,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono circular translúcido
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),

            // Valor destacado
            Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 6),

            // Etiqueta descriptiva
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
