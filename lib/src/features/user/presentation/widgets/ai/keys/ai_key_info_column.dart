import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Muestra el icono de IA, el nombre de la clave y su fecha de creación con resplandor hover.
/// ¿De dónde trae datos?: Ingesta nombre, fecha de la clave y estado hover.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido por AiKeyRowItem.
class AiKeyInfoColumn extends StatelessWidget {
  const AiKeyInfoColumn({
    required this.name,
    required this.createdAt,
    this.isHovered = false,
    super.key,
  });

  final String name;
  final String createdAt;
  final bool isHovered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: isHovered ? 0.20 : 0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.auto_awesome_rounded, size: 18, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor)),
              const SizedBox(height: 2),
              Text('Creada: $createdAt', style: TextStyle(fontSize: 11, color: subtitleColor)),
            ],
          ),
        ),
      ],
    );
  }
}
