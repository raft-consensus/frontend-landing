// ==========================================
// Qué hace: Contenedor individual con interacción Hover que ensambla DnsMetricIcon y DnsMetricContent.
// Dónde se conecta: Consumido por DnsSummaryCards.
// De dónde trae datos: Recibe value, title, icon e iconColor.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/summary/dns_metric_content.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/summary/dns_metric_icon.dart';

/// Tarjeta individual desacoplada con efecto de resplandor al pasar el cursor
class DnsMetricCard extends StatefulWidget {
  const DnsMetricCard({
    required this.value, // Valor cuantitativo o nombre de zona
    required this.title, // Etiqueta descriptiva
    required this.icon, // Icono representativo
    required this.iconColor, // Color del resplandor
    super.key,
  });

  final String value; // Valor numérico o texto principal
  final String title; // Etiqueta descriptiva
  final IconData icon; // Icono
  final Color iconColor; // Color distintivo

  @override
  State<DnsMetricCard> createState() => _DnsMetricCardState();
}

class _DnsMetricCardState extends State<DnsMetricCard> {
  bool _isHovered = false; // Estado reactivo de hover

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            // 1. Icono atómico
            DnsMetricIcon(
              icon: widget.icon,
              iconColor: widget.iconColor,
              isHovered: _isHovered,
            ),
            const SizedBox(width: 14),

            // 2. Textos atómicos de 2 líneas
            Expanded(
              child: DnsMetricContent(
                value: widget.value,
                title: widget.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
