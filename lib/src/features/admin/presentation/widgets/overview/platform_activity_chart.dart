import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/chart_label.dart'; // Widget


class PlatformActivityChart extends StatelessWidget {
  const PlatformActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividad de la plataforma',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Conexiones y consultas durante la última semana',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: 'Tiempo real',
                color: AppColors.green,
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 205,
            child: CustomPaint(
              painter: AdminChartPainter(),
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChartLabel('Lun'),
              ChartLabel('Mar'),
              ChartLabel('Mié'),
              ChartLabel('Jue'),
              ChartLabel('Vie'),
              ChartLabel('Sáb'),
              ChartLabel('Dom'),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    const values = [0.30, 0.46, 0.41, 0.70, 0.57, 0.84, 0.76];

    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath
          ..moveTo(x, size.height)
          ..lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blue.withOpacity(0.23),
            AppColors.blue.withOpacity(0.01),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = Colors.white,
      );

      canvas.drawCircle(
        Offset(x, y),
        3.2,
        Paint()..color = AppColors.blue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
