import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Painter personalizado que renderiza el fondo tecnológico animado de autenticación.
class DatabaseBackgroundPainter extends CustomPainter {
  DatabaseBackgroundPainter({required this.progress});

  /// Progreso de la animación del controlador (de 0.0 a 1.0) para hacer pulsar los nodos.
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibuja el fondo de degradado azul oscuro navy
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF031126), // Deep Navy
          AppColors.navy,
          Color(0xFF062B51),
        ],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, background);

    // 2. Dibuja la cuadrícula sutil (grid tech)
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.025)
      ..strokeWidth = 1;

    const spacing = 55.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 3. Coordenadas de los nodos interconectados en pantalla
    final nodes = <Offset>[
      Offset(size.width * 0.08, size.height * 0.20),
      Offset(size.width * 0.20, size.height * 0.38),
      Offset(size.width * 0.10, size.height * 0.72),
      Offset(size.width * 0.34, size.height * 0.81),
      Offset(size.width * 0.46, size.height * 0.20),
      Offset(size.width * 0.76, size.height * 0.12),
      Offset(size.width * 0.91, size.height * 0.35),
      Offset(size.width * 0.82, size.height * 0.75),
      Offset(size.width * 0.96, size.height * 0.89),
    ];

    // Dibuja las líneas que conectan los nodos
    final linePaint = Paint()
      ..color = AppColors.cyan.withOpacity(0.10)
      ..strokeWidth = 1.2;

    for (int i = 0; i < nodes.length - 1; i++) {
      canvas.drawLine(nodes[i], nodes[i + 1], linePaint);
    }

    // Dibuja los círculos con efecto de pulso animado
    for (int i = 0; i < nodes.length; i++) {
      final pulse = 2.5 +
          math.sin((progress * math.pi * 2) + i * 0.8).abs() * 2.5;

      canvas.drawCircle(
        nodes[i],
        pulse + 5,
        Paint()..color = AppColors.cyan.withOpacity(0.05),
      );

      canvas.drawCircle(
        nodes[i],
        pulse,
        Paint()..color = AppColors.cyan.withOpacity(0.35),
      );
    }

    // 4. Dibuja 2 iconos de base de datos flotantes a los lados
    _drawDatabase(
      canvas,
      Offset(size.width * 0.11, size.height * 0.52),
      44,
    );

    _drawDatabase(
      canvas,
      Offset(size.width * 0.88, size.height * 0.56),
      36,
    );
  }

  /// Método auxiliar que dibuja la silueta vectorial de un cilindro de BD.
  void _drawDatabase(
    Canvas canvas,
    Offset center,
    double width,
  ) {
    final paint = Paint()
      ..color = AppColors.blue.withOpacity(0.08)
      ..style = PaintingStyle.fill;

    final stroke = Paint()
      ..color = AppColors.cyan.withOpacity(0.13)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;

    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: width * 1.15,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      paint,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, rect.top + 5),
        width: width,
        height: 13,
      ),
      stroke,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy),
        width: width,
        height: 13,
      ),
      stroke,
    );

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, rect.bottom - 5),
        width: width,
        height: 13,
      ),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant DatabaseBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
