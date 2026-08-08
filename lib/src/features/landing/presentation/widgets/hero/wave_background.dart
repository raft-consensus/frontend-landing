// ==========================================
// ¿Qué hace?: Dibuja sutiles olas decorativas en el fondo de la HeroSection usando CustomPainter.
// ¿De dónde trae datos?: Detecta Theme.of(context).brightness para ajustar la opacidad del trazo.
// ¿Hacia dónde va / Cómo se conecta?: Posicionado en Stack al fondo de HeroSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final waveColor = isDark
        ? AppColors.nightBorder.withValues(alpha: 0.3)
        : AppColors.dayBorder.withValues(alpha: 0.5);

    return CustomPaint(
      painter: _WavePainter(waveColor: waveColor),
      child: const SizedBox.expand(),
    );
  }
}

class _WavePainter extends CustomPainter {
  const _WavePainter({required this.waveColor});

  final Color waveColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.7,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.8,
        size.width,
        size.height * 0.7,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
