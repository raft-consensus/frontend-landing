import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/providers/metrics_provider.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metrics_grid.dart';

/// Sección visual que muestra las estadísticas y métricas del proyecto en tiempo real.
/// 
/// ¿Qué hace?: Escucha las métricas desde Riverpod y delega la construcción de la cuadrícula a MetricsGrid.
/// ¿De dónde recibe datos?: Escucha reactivamente a platformMetricsProvider.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class MetricsSection extends ConsumerWidget {
  const MetricsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha de forma asíncrona el estado de las métricas desde Riverpod
    final metricsAsync = ref.watch(platformMetricsProvider);

    return SectionContainer(
      background: AppColors.surface,
      child: Column(
        children: [
          // Título de la sección reutilizable con antetítulo en cyan
          const SectionTitle(
            eyebrow: 'ESTADÍSTICAS EN TIEMPO REAL',
            title: 'Impacto de nuestra plataforma',
            subtitle:
                'Conoce la actividad real y el volumen de bases de datos aprovisionadas para nuestra comunidad.',
          ),
          const SizedBox(height: 48),

          // Renderizado condicional según el estado de la petición (data, loading, error)
          metricsAsync.when(
            data: (metrics) => MetricsGrid(metrics: metrics),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppColors.cyan),
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No se pudieron cargar las métricas en este momento.',
                  style: TextStyle(color: AppColors.muted),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
