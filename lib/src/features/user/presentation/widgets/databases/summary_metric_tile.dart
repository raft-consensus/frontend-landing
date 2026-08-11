// ==========================================
// Qué hace: Renderiza una métrica individual de resumen con icono coloreado, etiqueta y valor numérico.
// Dónde se conecta: Importado por DatabaseSummaryCard.
// De dónde recibe datos: Recibe label, value, icon e iconColor.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// Widget modular para mostrar métricas individuales en la tarjeta resumen
class SummaryMetricTile extends StatelessWidget {
  const SummaryMetricTile({
    required this.label,     // Etiqueta descriptiva (ej. "Instancias Activas")
    required this.value,     // Valor cuantitativo (ej. "12 / 12")
    required this.icon,      // Icono representativo de la métrica
    required this.iconColor, // Color distintivo del icono
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: subtitleColor, fontSize: 11)),
            Text(
              value,
              style: TextStyle(
                color: titleColor,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
