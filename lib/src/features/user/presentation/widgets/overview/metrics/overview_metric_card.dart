// ==========================================
// Qué hace: Tarjeta individual horizontal de métrica (Icono | Contador | Separador | Nombre).
// Dónde se conecta: Consumido por OverviewMetricsGrid.
// De dónde trae datos: Recibe title, value, icon y subtitle.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Tarjeta individual desacoplada para los KPIs del panel de resumen
class OverviewMetricCard extends StatefulWidget {
  const OverviewMetricCard({
    required this.title, // Nombre del servicio (ej: "Bases de Datos")
    required this.value, // Contador cuantitativo (ej: "5")
    required this.icon, // Icono representativo
    this.subtitle = '', // Mantenido para compatibilidad opcional
    super.key,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  State<OverviewMetricCard> createState() => _OverviewMetricCardState();
}

class _OverviewMetricCardState extends State<OverviewMetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    final borderColor = _isHovered
        ? primaryColor.withValues(alpha: 0.50)
        : (isDark ? AppColors.nightBorder : AppColors.dayBorder);

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final iconBg = isDark ? const Color(0xFF1E2D40) : const Color(0xFFEBF3FC);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0xFF152436) : const Color(0xFFF3F8FE))
              : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.0),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Icono del servicio
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(widget.icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 10),

            // 2. Contador cuantitativo
            Text(
              widget.value,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 10),

            // 3. Separador "|"
            Text(
              '|',
              style: TextStyle(
                color: subtitleColor.withValues(alpha: 0.40),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 10),

            // 4. Nombre del servicio
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
