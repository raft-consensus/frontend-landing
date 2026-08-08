import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_data.dart';
import 'package:go_router/go_router.dart';

/// ¿Qué hace?: Sección visual del proceso 'Cómo Funciona' en 4 sencillos pasos multiservicio.
/// ¿De dónde trae datos?: Lista interna inmutable de objetos StepData adaptados a los 4 servicios.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye directamente en LandingPage.
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    // Listado inmutable de los 4 pasos multiservicio
    const steps = [
      StepData(
        '01',
        Icons.person_add_alt_1_rounded,
        'Crea tu cuenta gratis',
        'Regístrate en segundos como estudiante o desarrollador sin tarjeta de crédito.',
      ),
      StepData(
        '02',
        Icons.hub_rounded,
        'Selecciona un servicio',
        'Elige entre BDs (SQL/NoSQL), Subdominios DNS con SSL, API Keys de IA o n8n.',
      ),
      StepData(
        '03',
        Icons.settings_suggest_rounded,
        'Configura tus datos',
        'Asigna un nombre a tu instancia, genera credenciales seguras o activa tus llaves de API.',
      ),
      StepData(
        '04',
        Icons.code_rounded,
        'Conecta tu aplicación',
        'Usa las cadenas de conexión desde Flutter, Node, Python, C# o tu cliente preferido.',
      ),
    ];

    return SectionContainer(
      background: isDark ? AppColors.nightBackground : Colors.white,
      child: Column(
        children: [
          // Encabezado estandarizado de la sección
          const SectionTitle(
            eyebrow: 'CÓMO FUNCIONA',
            title: 'De cero a tu primer servicio en minutos',
            subtitle: 'Una experiencia intuitiva y rápida para potenciar tus proyectos.',
          ),
          const SizedBox(height: 48),

          // Grilla responsiva de 4 pasos
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // 4 columnas en escritorio (>950px), 2 en tablet (>580px), 1 en móvil
              final itemWidth = width > 950
                  ? (width - 48) / 4
                  : width > 580
                      ? (width - 16) / 2
                      : width;

              return Wrap(
                spacing: 16,
                runSpacing: 24,
                children: steps
                    .map((step) => StepCard(width: itemWidth, data: step))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 45),

          // Botón de llamado a la acción al final del flujo
          FilledButton.icon(
            onPressed: () => context.push('/register'),
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Comenzar gratis'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
              foregroundColor: isDark ? AppColors.nightBackground : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            ),
          ),
        ],
      ),
    );
  }
}
