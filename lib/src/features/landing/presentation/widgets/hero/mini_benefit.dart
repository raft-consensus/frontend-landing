// ==========================================
// ¿Qué hace?: Viñeta corta con checkmark para destacar beneficios rápidos en la HeroSection.
// ¿De dónde trae datos?: Ingesta la etiqueta textual y adapta los colores de texto e icono al tema.
// ¿Hacia dónde va / Cómo se conecta?: Invocado al final del contenido en HeroSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class MiniBenefit extends StatelessWidget {
  const MiniBenefit(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded, // Icono check de color éxito
          size: 16,
          color: AppColors.success,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
