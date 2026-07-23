import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta con gráfico dibujado en lienzo (CustomPainter) de métricas de tráfico semanal.
/// ¿De dónde trae?: Trae AppColors (core) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se muestra en OverviewPage para resumir la actividad de la semana.
class UsageChartCard extends StatelessWidget {
  const UsageChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
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
                      'Actividad de Consultas (Semanal)',
                      style: TextStyle(color: AppColors.navy, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      'Promedio diario: 1,420 peticiones',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(Icons.auto_graph_rounded, color: AppColors.blue),
            ],
          ),
          const SizedBox(height: 24),

          // Lienzo de dibujo gráfico personalizado (CustomPaint)
          SizedBox(
            height: 140,
            width: double.infinity,
            child: CustomPaint(
              painter: UsageChartPainter(),
            ),
          ),
          const SizedBox(height: 16),

          // Leyenda de días de la semana
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lun', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Mar', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Mié', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Jue', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Vie', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Sáb', style: TextStyle(color: AppColors.muted, fontSize: 11)),
              Text('Dom', style: TextStyle(color: AppColors.muted, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Painter personalizado que dibuja las curvas de nivel y líneas del gráfico de consultas
class UsageChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = AppColors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.blue.withOpacity(0.25),
          AppColors.blue.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.16, size.height * 0.4),
      Offset(size.width * 0.33, size.height * 0.55),
      Offset(size.width * 0.50, size.height * 0.2),
      Offset(size.width * 0.66, size.height * 0.45),
      Offset(size.width * 0.83, size.height * 0.3),
      Offset(size.width, size.height * 0.6),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
