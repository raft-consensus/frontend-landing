import 'package:flutter/material.dart';

/// ¿Qué hace?: Widget atómico que representa una tarjeta individual de plantilla recomendada.
/// ¿De dónde trae datos?: Ingesta título, descripción, icono, color distintivo y callback de uso.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del Flex en N8nTemplatesSection.
class N8nTemplateCardItem extends StatelessWidget {
  final String title;                    // Título descriptivo de la plantilla
  final String desc;                     // Explicación de la plantilla
  final IconData icon;                   // Icono representativo
  final Color color;                     // Color acento del icono
  final void Function(String) onUse;     // Callback al presionar "Usar Plantilla"

  const N8nTemplateCardItem({
    required this.title,
    required this.desc,
    required this.icon,
    required this.color,
    required this.onUse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[700];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(title, style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: subtitleColor, fontSize: 11)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => onUse(title),
            icon: const Icon(Icons.add_circle_outline_rounded, size: 14),
            label: const Text('Usar Plantilla', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
