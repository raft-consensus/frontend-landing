// ==========================================
// Qué hace: Ilustración oficial de la balsa náutica con margen adaptativo y cambio de imagen día/noche.
// Dónde se conecta: Consumido dentro de WelcomeBanner.
// De dónde trae datos: Detecta Theme.of(context) para alternar entre logo_night y logo_light.
// ==========================================

import 'package:flutter/material.dart';

/// Ilustración náutica para el extremo derecho del banner de bienvenida
class WelcomeBannerIllustration extends StatelessWidget {
  const WelcomeBannerIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoPath = isDark ? 'lib/src/img/in/logo_night.png' : 'lib/src/img/in/logo_light.png';

    return Padding(
      padding: const EdgeInsets.only(right: 28),
      child: SizedBox(
        height: 175,
        child: Image.asset(
          logoPath,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'lib/src/img/image_logo_02.png',
            height: 175,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.sailing_rounded,
              size: 70,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
