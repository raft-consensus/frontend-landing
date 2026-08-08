import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/providers/metrics_provider.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metrics_grid.dart';

/// ¿Qué hace?: Sección de estadísticas en tiempo real adaptable al tema activo (Day/Night).
/// ¿De dónde trae datos?: Escucha reactivamente a platformMetricsProvider vía Riverpod.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye como segunda sección en LandingPage.
class MetricsSection extends ConsumerWidget {
  const MetricsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha de forma asíncrona las métricas desde Riverpod
    final metricsAsync = ref.watch(platformMetricsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SectionContainer(
      background: isDark ? AppColors.nightSurface : const Color(0xFFF0F4F8), // colores de fondo
      child: Column(
        children: [
          // Título estandarizado de la sección
          const SectionTitle(
            eyebrow: 'ESTADÍSTICAS EN TIEMPO REAL',
            title: 'Impacto de nuestra plataforma',
            subtitle:
                'Conoce la actividad real y el volumen de servicios provistos para nuestra comunidad.',
          ),
          const SizedBox(height: 48),

          // Renderizado condicional del estado asíncrono
          metricsAsync.when(
            data: (metrics) => MetricsGrid(metrics: metrics),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: AppColors.cyan),
              ),
            ),
            error: (error, _) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
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
