import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Elemento desplegable individual (ExpansionTile) para el acordeón de FAQ.
/// ¿De dónde trae datos?: Ingesta la pregunta string y la respuesta string desde FaqSection.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en la lista de items de FaqSection.
class FaqTile extends StatelessWidget {
  const FaqTile({
    required this.question, // Pregunta frecuente
    required this.answer, // Respuesta explicativa
    super.key,
  });

  final String question; // Texto de la pregunta
  final String answer; // Texto de la respuesta

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface; // Fondo dinámico
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde dinámico
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Título dinámico
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Respuesta dinámica

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text(
          question,
          style: TextStyle(color: titleColor, fontSize: 15, fontWeight: FontWeight.w700),
        ),
        iconColor: AppColors.cyan, // Icono desplegado cyan
        collapsedIconColor: textColor,
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: TextStyle(color: textColor, fontSize: 13, height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}
