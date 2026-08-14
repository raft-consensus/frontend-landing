import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metric_card.dart';

/// ¿Qué hace?: Grilla responsiva que organiza las 6 tarjetas de métricas reales del ecosistema.
/// ¿De dónde trae datos?: Ingesta la entidad de dominio PlatformMetrics provista por MetricsSection.
/// ¿Hacia dónde va / Cómo se conecta?: Renderizado en el estado de éxito 'data' de MetricsSection.
class MetricsGrid extends StatelessWidget {
  const MetricsGrid({
    required this.metrics, // Entidad de métricas globales de la plataforma
    super.key,
  });

  final PlatformMetrics metrics; // Instancia inyectada con datos de backend

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    // Colores de icono luminosos con alto contraste según el tema activo (Day/Night)
    final userIconColor = isDark ? const Color(0xFF64B5F6) : AppColors.dayPrimary; // Color tarjeta usuarios
    final dbIconColor = isDark ? AppColors.cyan : AppColors.cyan; // Color tarjeta bases de datos
    final dnsIconColor = isDark ? const Color(0xFF4FC3F7) : const Color(0xFF2C7BC9); // Color tarjeta DNS
    final aiIconColor = isDark ? const Color(0xFF81C784) : const Color(0xFF2F9E6D); // Color tarjeta IA
    final n8nIconColor = isDark ? const Color(0xFFFFB74D) : const Color(0xFFF28C28); // Color tarjeta n8n
    final auditIconColor = isDark ? const Color(0xFF66BB6A) : const Color(0xFF00897B); // Color tarjeta auditoría

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth; // Ancho disponible

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
            // Métrica 1: Comunidad total de usuarios
            MetricCard(
              width: cardWidth,
              icon: Icons.people_outline_rounded,
              value: '${metrics.totalUsers}',
              label: 'Usuarios Registrados',
              color: userIconColor,
            ),

            // Métrica 2: Total de bases de datos en la plataforma (no solo activas)
            MetricCard(
              width: cardWidth,
              icon: Icons.storage_rounded,
              value: '${metrics.totalDatabases}',
              label: 'Bases de Datos',
              color: dbIconColor,
            ),

            // Métrica 3: Subdominios DNS activos
            MetricCard(
              width: cardWidth,
              icon: Icons.language_rounded,
              value: '${metrics.totalSubdomains}',
              label: 'Subdominios DNS',
              color: dnsIconColor,
            ),

            // Métrica 4: Peticiones a modelos de IA
            MetricCard(
              width: cardWidth,
              icon: Icons.auto_awesome_rounded,
              value: '${metrics.totalAiRequests}',
              label: 'Consultas IA Generadas',
              color: aiIconColor,
            ),

            // Métrica 5: Flujos de automatización n8n ejecutados
            MetricCard(
              width: cardWidth,
              icon: Icons.account_tree_rounded,
              value: '${metrics.totalN8nExecutions}',
              label: 'Flujos n8n Ejecutados',
              color: n8nIconColor,
            ),

            // Métrica 6: Operaciones seguras auditadas en el sistema
            MetricCard(
              width: cardWidth,
              icon: Icons.security_rounded,
              value: '${metrics.totalSecureOperations}',
              label: 'Operaciones Auditadas',
              color: auditIconColor,
            ),
          ],
        );
      },
    );
  }
}
