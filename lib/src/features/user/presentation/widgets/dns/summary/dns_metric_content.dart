// ==========================================
// Qué hace: Bloque tipográfico con 2 líneas limpias (Valor destacado + Etiqueta descriptiva).
// Dónde se conecta: Consumido internamente por DnsMetricCard.
// De dónde trae datos: Recibe value y title adaptándose al tema activo (Day/Night).
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Contenido textual de 2 líneas de la tarjeta métrica DNS
class DnsMetricContent extends StatelessWidget {
  const DnsMetricContent({
    required this.value, // Valor numérico o texto principal (ej: "coderhivex.com")
    required this.title, // Etiqueta descriptiva (ej: "Zona Activa Cloudflare")
    super.key,
  });

  final String value; // Valor principal
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
        // Línea 1: Métrica o identificador principal destacado
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.w900,
            fontSize: 15,
            letterSpacing: -0.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
