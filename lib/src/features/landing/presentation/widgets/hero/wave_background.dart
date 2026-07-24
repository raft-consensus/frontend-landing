import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Widget wrapper que renderiza el CustomPainter de olas de fondo.
class WaveBackground extends StatelessWidget {
  const WaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WavePainter(),
    );
  }
}

/// Painter personalizado que dibuja curvas bézier (olas) dinámicas usando el Canvas 2D de Flutter.
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dibuja 6 líneas de olas paralelas con desplazamientos verticales
    for (int i = 0; i < 6; i++) {
      final y = size.height * 0.72 + (i * 25);
      final path = Path()..moveTo(0, y);

      // Curva bézier cúbica 1
      path.cubicTo(
        size.width * 0.25,
        y - 80,
        size.width * 0.35,
        y + 80,
        size.width * 0.55,
        y,
      );

      // Curva bézier cúbica 2
      path.cubicTo(
        size.width * 0.75,
        y - 80,
        size.width * 0.85,
        y + 60,
        size.width,
        y,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
