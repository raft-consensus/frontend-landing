import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';

/// ¿Qué hace?: Tarjeta individual con animación hover para presentar cada beneficio del ecosistema.
/// ¿De dónde trae datos?: Ingesta la entidad BenefitData y el ancho deseado (width).
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en la grilla de BenefitsSection.
class BenefitCard extends StatelessWidget {
  const BenefitCard({
    required this.width, // Ancho calculado dinámicamente según pantalla
    required this.data, // Datos del beneficio (icono, título, descripción, color)
    super.key,
  });

  final double width;
  final BenefitData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface; // Fondo dinámico
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde dinámico
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Título
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Descripción

    return HoverCard(
      borderRadius: 18,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono circular tintado con alto contraste
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: isDark ? 0.22 : 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(data.icon, color: data.color, size: 26),
            ),
            const SizedBox(height: 18),

            // Título del beneficio
            Text(
              data.title,
              style: TextStyle(
                color: titleColor,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción detallada
            Text(
              data.description,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
