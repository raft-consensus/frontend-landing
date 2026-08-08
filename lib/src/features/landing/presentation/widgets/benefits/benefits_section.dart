import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';

/// ¿Qué hace?: Sección visual que presenta los 6 beneficios clave de construir en Raft Cloud.
/// ¿De dónde trae datos?: Colección inmutable de objetos BenefitData adaptada a los 4 servicios.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye directamente en LandingPage.
class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    // 6 beneficios actualizados para reflejar los 4 servicios y la comunidad tech
    final benefits = [
      BenefitData(
        Icons.bolt_rounded,
        'Creación instantánea',
        'Despliega bases de datos, subdominios DNS, API Keys de IA y flujos n8n en segundos.',
        isDark ? const Color(0xFFFFD54F) : const Color(0xFFFFB020),
      ),
      BenefitData(
        Icons.shield_rounded,
        'Acceso seguro y aislado',
        'Credenciales individuales, subdominios protegidos con SSL y aislamiento total de recursos.',
        isDark ? const Color(0xFF64B5F6) : const Color(0xFF0878D1),
      ),
      BenefitData(
        Icons.school_rounded,
        'Diseñado para aprender',
        'Practica consultas SQL/NoSQL, enrutamiento DNS, consumo de IA y automatización sin instalar nada.',
        isDark ? const Color(0xFFB388FF) : const Color(0xFF7047E8),
      ),
      BenefitData(
        Icons.hub_rounded,
        '4 Servicios Integrados',
        'Bases de datos relacionales/NoSQL, gestión de red, inteligencia artificial y n8n unificados.',
        isDark ? const Color(0xFF4DD0E1) : const Color(0xFF0BB6B2),
      ),
      BenefitData(
        Icons.people_rounded,
        'Para la comunidad tech',
        'Ideal para estudiantes, desarrolladores y docentes que crean prototipos y proyectos sin costo.',
        isDark ? const Color(0xFFFF8A65) : const Color(0xFFEA4A61),
      ),
      BenefitData(
        Icons.dashboard_rounded,
        'Panel centralizado',
        'Monitorea métricas, gestiona credenciales y consulta el estado de todos tus servicios.',
        isDark ? const Color(0xFF81C784) : const Color(0xFF19A85B),
      ),
    ];

    return SectionContainer(
      background: isDark ? AppColors.nightSurface : const Color(0xFFEEF5FC),
      child: Column(
        children: [
          // Título estandarizado de la sección
          const SectionTitle(
            eyebrow: 'BENEFICIOS CLAVE',
            title: 'Todo lo necesario para construir',
            subtitle:
                'Olvídate de instalaciones complejas y concéntrate en desarrollar tus ideas.',
          ),
          const SizedBox(height: 42),

          // Grilla responsiva de 6 tarjetas de beneficios
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width > 900
                  ? (width - 40) / 3
                  : width > 580
                      ? (width - 20) / 2
                      : width;

              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: benefits
                    .map((item) => BenefitCard(width: cardWidth, data: item))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
