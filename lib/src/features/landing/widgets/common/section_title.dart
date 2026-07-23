import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget de título compuesto para secciones de la Landing.
/// Muestra un antetítulo (eyebrow), un título destacado y un subtítulo descriptivo.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.light = false,
    super.key,
  });

  /// Antetítulo corto en mayúsculas (ej. "MOTORES DISPONIBLES").
  final String eyebrow;

  /// Título principal de la sección (ej. "Trabaja con tus bases de datos favoritas").
  final String title;

  /// Subtítulo o descripción explicativa bajo el título.
  final String subtitle;

  /// Controla si se renderiza en modo claro u oscuro (para secciones con fondo azul navy).
  final bool light;

  @override
  Widget build(BuildContext context) {
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

        // 2. Título principal en estilo destacado headlineLarge (cambia de color según el modo light)
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: light ? Colors.white : AppColors.navy,
              ),
        ),
        const SizedBox(height: 14),

        // 3. Subtítulo limitado a 680px de ancho para que no quede una línea excesivamente larga
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: light
                  ? const Color(0xFFB7C8DD)
                  : const Color(0xFF607189),
              fontSize: 16,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}
