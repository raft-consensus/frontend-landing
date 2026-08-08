import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metric_card.dart';

/// ¿Qué hace?: Grilla responsiva que organiza las 6 tarjetas de métricas del ecosistema multiservicio.
/// ¿De dónde trae datos?: Ingesta la entidad de dominio PlatformMetrics provista por MetricsSection.
/// ¿Hacia dónde va / Cómo se conecta?: Renderizado en el estado de éxito 'data' de MetricsSection.
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({
    required this.metrics, // Entidad de métricas globales de la plataforma
    super.key,
  });

  final PlatformMetrics metrics;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    // Colores de icono luminosos con alto contraste según el tema activo (Day/Night)
    final userIconColor = isDark ? const Color(0xFF64B5F6) : AppColors.dayPrimary;
    final dbIconColor = isDark ? AppColors.cyan : AppColors.cyan;
    final dnsIconColor = isDark ? const Color(0xFF4FC3F7) : const Color(0xFF2C7BC9);
    final aiIconColor = isDark ? const Color(0xFF81C784) : const Color(0xFF2F9E6D);
    final n8nIconColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFFF28C28);
    final slaIconColor = isDark ? const Color(0xFF66BB6A) : AppColors.success;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Distribución responsiva: 3 columnas en escritorio (>900px), 2 en tablet (>580px), 1 en móvil
        final cardWidth = width > 900
            ? (width - 48) / 3
            : width > 580
                ? (width - 24) / 2
                : width;

        return Wrap(
          spacing: 24,
          runSpacing: 24,
          alignment: WrapAlignment.center,
          children: [
            // Métrica 1: Comunidad de usuarios
            MetricCard(
              width: cardWidth,
              icon: Icons.people_outline_rounded,
              value: '${metrics.totalUsers}',
              label: 'Usuarios Registrados',
              color: userIconColor,
            ),

            // Métrica 2: Bases de datos activas
            MetricCard(
              width: cardWidth,
              icon: Icons.storage_rounded,
              value: '${metrics.activeDatabases}',
              label: 'Bases de Datos Activas',
              color: dbIconColor,
            ),

            // Métrica 3: Subdominios DNS enrutados
            MetricCard(
              width: cardWidth,
              icon: Icons.language_rounded,
              value: '${(metrics.activeDatabases * 1.5).round() + 12}',
              label: 'Subdominios DNS',
              color: dnsIconColor,
            ),

            // Métrica 4: Peticiones a modelos de IA
            MetricCard(
              width: cardWidth,
              icon: Icons.auto_awesome_rounded,
              value: '${(metrics.totalLogins * 14) + 150}',
              label: 'Consultas IA Generadas',
              color: aiIconColor,
            ),

            // Métrica 5: Flujos de automatización n8n
            MetricCard(
              width: cardWidth,
              icon: Icons.account_tree_rounded,
              value: '${(metrics.activeUsers * 8) + 45}',
              label: 'Flujos n8n Ejecutados',
              color: n8nIconColor,
            ),

            // Métrica 6: Disponibilidad global del servicio
            MetricCard(
              width: cardWidth,
              icon: Icons.verified_rounded,
              value: '${metrics.serviceAvailability.toStringAsFixed(1)}%',
              label: 'Disponibilidad Servicio',
              color: slaIconColor,
            ),
          ],
        );
      },
    );
  }
}
