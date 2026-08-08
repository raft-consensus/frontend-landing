import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Tarjeta informativa horizontal con disposition Icono | Contador | Separador | Nombre y resplandor hover de color 100% estático.
/// ¿De dónde trae datos?: Ingesta título, valor e icono. No cambia el tamaño del borde para evitar desplazamiento.
/// ¿Hacia dónde va / Cómo se conecta?: Renderizado en la fila superior de métricas dentro de OverviewPage.
class MetricCard extends StatefulWidget {
  const MetricCard({
    required this.title,   // Nombre en 1 sola línea (ej: "Bases de Datos")
    required this.value,   // Contador cuantitativo (ej: "5")
    required this.icon,    // Icono representativo
    this.subtitle = '',    // Mantenido para compatibilidad opcional
    super.key,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si el tema activo es oscuro (Raft Night)
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 2. Colores dinámicos y primarios
    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    // Borde de color dinámico pero SIEMPRE con grosor fijo 1.0 (anti-movimiento)
    final borderColor = _isHovered
        ? primaryColor.withValues(alpha: 0.50)
        : (isDark ? AppColors.nightBorder : AppColors.dayBorder);

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final iconBg = isDark ? const Color(0xFF1E2D40) : const Color(0xFFEBF3FC);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic, // 👈 Cursor normal (sin manito de botón)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _isHovered
              ? (isDark ? const Color(0xFF152436) : const Color(0xFFF3F8FE))
              : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.0), // 👈 Grosor fijo permanente
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Icono del servicio a la izquierda
            _MetricIcon(icon: widget.icon, iconBg: iconBg, iconColor: primaryColor),
            const SizedBox(width: 10),

            // 2. Contador numérico grande al centro
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

            // 3. Separador literal "|" tintado
            Text(
              '|',
              style: TextStyle(
                color: subtitleColor.withValues(alpha: 0.40),
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(width: 10),

            // 4. Nombre del servicio en UNA SOLA LÍNEA
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

/// Sub-widget privado 1: Insignia cuadrada con icono del servicio
class _MetricIcon extends StatelessWidget {
  const _MetricIcon({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: iconBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
