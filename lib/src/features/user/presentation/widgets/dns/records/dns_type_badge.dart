// ==========================================
// Qué hace: Insignia atómica para mostrar el tipo de registro DNS (ej: "A", "CNAME").
// Dónde se conecta: Consumido por las filas de subdominios.
// De dónde trae datos: Recibe el tipo en String.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Insignia del tipo de registro DNS
class DnsTypeBadge extends StatelessWidget {
  const DnsTypeBadge({required this.type, super.key});

  final String type; // Tipo de registro (ej. "A")

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: isDark ? 0.30 : 0.50),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
        ),
      ),
    );
  }
}
