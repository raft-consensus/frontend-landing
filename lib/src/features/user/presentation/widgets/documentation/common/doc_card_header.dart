// ==========================================
// Que hace: Encabezado atomico de la tarjeta con icono, titulo, badge de lenguaje y tiempo de lectura.
// De donde trae datos: Recibe titulo, icono, color, badge y tiempo estimado.
// Donde se conecta: Consumido dentro de DocExpandableCard.
// ==========================================

import 'package:flutter/material.dart';

/// Encabezado modular de tarjeta documental
class DocCardHeader extends StatelessWidget {
  const DocCardHeader({
    required this.title, // Titulo de la guia
    required this.icon, // Icono del lenguaje o herramienta
    required this.badgeText, // Texto de la insignia
    required this.color, // Color tematico
    this.estimatedTime, // Tiempo opcional de lectura
    super.key,
  });

  final String title;
  final IconData icon;
  final String badgeText;
  final Color color;
  final String? estimatedTime;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Caja contenedora de icono
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: isDark ? 0.35 : 0.20)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 14),

        // Textos y badge
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: isDark ? 0.20 : 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              if (estimatedTime != null) ...[
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 12,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      estimatedTime!,
                      style: TextStyle(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
