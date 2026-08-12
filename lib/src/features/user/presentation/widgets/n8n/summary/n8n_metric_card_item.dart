import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Widget atómico que renderiza una tarjeta KPI individual con icono, títulos y efecto hover resplandeciente.
/// ¿De dónde trae datos?: Propiedades de título, valor, subtítulo, icono y color configurado.
/// ¿Hacia dónde va / Cómo se conecta?: Se consume dentro de N8nSummaryCards.
class N8nMetricCardItem extends StatefulWidget {
  final String title;     // Título secundario del indicador
  final String value;     // Valor numérico o texto principal
  final String subtitle;  // Texto descriptivo adicional
  final IconData icon;    // Icono del indicador
  final Color iconColor;  // Color del icono y efecto resplandeciente

  const N8nMetricCardItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    super.key,
  });

  @override
  State<N8nMetricCardItem> createState() => _N8nMetricCardItemState();
}

class _N8nMetricCardItemState extends State<N8nMetricCardItem> {
  bool _isHovered = false; // Control del cursor al pasar por encima

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withValues(alpha: isDark ? 0.50 : 0.40)
                : theme.dividerColor,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: _isHovered ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(color: subtitleColor, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(widget.value, style: TextStyle(color: titleColor, fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
