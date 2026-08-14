// ==========================================
// Qué hace: Bloque tipográfico con 2 líneas limpias (Valor destacado + Etiqueta descriptiva).
// Dónde se conecta: Consumido internamente por AiMetricCard.
// De dónde trae datos: Recibe value y title adaptándose al tema activo (Day/Night).
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Contenido textual de 2 líneas de la tarjeta métrica
class AiMetricContent extends StatelessWidget {
  const AiMetricContent({
    required this.value, // Valor numérico principal (ej: "1 / 10 Claves")
    required this.title, // Etiqueta descriptiva (ej: "API Keys Activas")
    super.key,
  });

  final String value; // Valor
  final String title; // Título o descripción

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Línea 1: Métrica principal destacada
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 2),

        // Línea 2: Etiqueta descriptiva
        Text(
          title,
          style: TextStyle(
            color: labelColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
