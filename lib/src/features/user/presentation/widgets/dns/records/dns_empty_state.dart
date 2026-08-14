// ==========================================
// Qué hace: Vista para cuando no existen registros DNS registrados o no coinciden con la búsqueda.
// Dónde se conecta: Consumido por DnsTable cuando la lista está vacía.
// De dónde trae datos: Se adapta al tema activo.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Estado vacío del módulo DNS
class DnsEmptyState extends StatelessWidget {
  const DnsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(Icons.dns_outlined, size: 48, color: subtitleColor),
          const SizedBox(height: 12),
          Text(
            'No se encontraron registros DNS',
            style: TextStyle(fontWeight: FontWeight.bold, color: titleColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Crea un nuevo subdominio o modifica los términos de búsqueda',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
