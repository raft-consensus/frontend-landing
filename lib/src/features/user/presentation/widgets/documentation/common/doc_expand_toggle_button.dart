// ==========================================
// Que hace: Boton atomico para expandir u ocultar el codigo de ejemplo de una guia.
// De donde trae datos: Recibe el booleano isExpanded, el color y el callback onToggle.
// Donde se conecta: Consumido al pie de DocExpandableCard.
// ==========================================

import 'package:flutter/material.dart';

/// Boton toggle simple para controlar la visualizacion del codigo
class DocExpandToggleButton extends StatelessWidget {
  const DocExpandToggleButton({
    required this.isExpanded, // Estado de expansion
    required this.onToggle, // Callback para alternar
    required this.color, // Color del texto e icono
    super.key,
  });

  final bool isExpanded;
  final VoidCallback onToggle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onToggle,
      icon: Icon(
        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.code_rounded,
        size: 16,
      ),
      label: Text(isExpanded ? 'Ocultar código' : 'Ver código de ejemplo'),
      style: TextButton.styleFrom(
        foregroundColor: color,
        padding: EdgeInsets.zero,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
