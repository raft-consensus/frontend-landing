import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Renderiza la ilustración balsa oficial en gran tamaño ocupando el espacio derecho de la HeroSection.
/// ¿De dónde trae datos?: Ingesta Theme.of(context).brightness para alternar dinámicamente entre logo_night.png y logo_light.png.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado en la columna/fila derecha de HeroSection.
class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    // Ruta de la imagen isotipo oficial según el modo activo
    final logoPath = isDark
        ? 'lib/src/img/in/logo_night.png'
        : 'lib/src/img/in/logo_light.png';

    return Center(
      child: Image.asset(
        logoPath,
        height: 340, // Tamaño prominente que ocupa el área de la HeroSection
        fit: BoxFit.contain, // Ajuste sin deformar
        errorBuilder: (context, error, stackTrace) => const Icon(
          Icons.sailing_rounded,
          color: AppColors.cyan,
          size: 180,
        ),
      ),
    );
  }
}
