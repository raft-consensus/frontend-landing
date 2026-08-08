// ==========================================
// Archivo: lib/src/features/landing/presentation/widgets/common/section_title.dart
// ¿Qué hace?: Widget de título compuesto para las secciones de la Landing Page con adaptación Day/Night.
// ¿De dónde trae datos?: Recibe antetítulo (eyebrow), título, subtítulo y parámetro opcional light.
// ¿Hacia dónde va / Cómo se conecta?: Se incluye al inicio de cada sección en la Landing Page.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.light,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final bool? light;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si la sección debe mostrarse en tono oscuro (vía tema activo u override manual)
    final isDark = light ?? (Theme.of(context).brightness == Brightness.dark);
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Column(
      children: [
        // 1. Antetítulo en color Cyan brillante con espaciado entre letras
        Text(
          eyebrow,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.cyan,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 13),

        // 2. Título principal destacado con color dinámico
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: titleColor,
              ),
        ),
        const SizedBox(height: 14),

        // 3. Subtítulo limitado a 680px para óptima legibilidad
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: subtitleColor,
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}
