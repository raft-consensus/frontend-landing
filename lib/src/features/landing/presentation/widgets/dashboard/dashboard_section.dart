import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/dashboard/dashboard_feature.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/dashboard/dashboard_mockup.dart';

/// Sección de demostración del Panel de Control (Dashboard Preview).
/// 
/// ¿Qué hace?: Muestra la descripción de la plataforma a la izquierda y el mockup del panel a la derecha en vista de escritorio.
/// ¿De dónde recibe datos?: Se compone con DashboardFeature y DashboardMockup.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      background: const Color(0xFFEAF5FF),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final desktop = constraints.maxWidth > 900;

          final description = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TU CENTRO DE CONTROL',
                style: TextStyle(
                  color: AppColors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Administra todo desde un solo lugar',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 18),
              const Text(
                'Consulta el estado de tus instancias, copia credenciales, '
                'reinicia servicios y accede a herramientas de diagnóstico '
                'desde un panel sencillo.',
                style: TextStyle(
                  color: Color(0xFF52647C),
                  fontSize: 17,
                  height: 1.65,
                ),
              ),
              const SizedBox(height: 22),
              const DashboardFeature('Estado en tiempo real'),
              const DashboardFeature('Credenciales de conexión'),
              const DashboardFeature('Acciones rápidas'),
            ],
          );

          if (!desktop) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                description,
                const SizedBox(height: 40),
                const DashboardMockup(),
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 4, child: description),
              const SizedBox(width: 60),
              const Expanded(flex: 6, child: DashboardMockup()),
            ],
          );
        },
      ),
    );
  }
}
