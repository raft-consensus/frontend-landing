import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_data.dart';

/// ¿Qué hace?: Tarjeta individual con animación hover para presentar cada paso del proceso con badge numérico.
/// ¿De dónde trae datos?: Ingesta el objeto StepData y el ancho deseado (width).
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en la grilla de HowItWorksSection.
class StepCard extends StatelessWidget {
  const StepCard({
    required this.width, // Ancho calculado dinámicamente según pantalla
    required this.data, // Datos del paso (número, icono, título, descripción)
    super.key,
  });

  final double width;
  final StepData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface; // Fondo dinámico
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde dinámico
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Título
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Descripción
    final badgeBg = isDark ? AppColors.nightBackground : AppColors.dayPrimary; // Fondo badge
    final badgeTextColor = isDark ? AppColors.cyan : Colors.white; // Texto badge

    return HoverCard(
      borderRadius: 18,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(22),
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
          children: [
            // Icono en caja gradiente con badge numérico destacado
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.cyan, AppColors.blue],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(data.icon, color: Colors.white, size: 30),
                ),
                Positioned(
                  top: -6,
                  right: -6,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: badgeBg,
                    child: Text(
                      data.number,
                      style: TextStyle(
                        color: badgeTextColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Título del paso
            Text(
              data.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),

            // Descripción explicativa
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
