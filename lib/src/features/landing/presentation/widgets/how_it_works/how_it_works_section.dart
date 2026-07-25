import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_data.dart';

/// Sección visual que explica el proceso 'Cómo Funciona' paso a paso.
/// 
/// ¿Qué hace?: Agrupa 4 etapas numéricas desde el registro hasta la primera conexión y muestra un botón CTA.
/// ¿De dónde recibe datos?: Lista interna inmutable de objetos StepData.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      StepData(
        '01',
        Icons.person_add_alt_1_rounded,
        'Crea tu cuenta',
        'Regístrate gratuitamente como estudiante o desarrollador.',
      ),
      StepData(
        '02',
        Icons.storage_rounded,
        'Elige un motor',
        'Selecciona MySQL, PostgreSQL, SQL Server o MongoDB.',
      ),
      StepData(
        '03',
        Icons.settings_suggest_rounded,
        'Crea tu instancia',
        'Define un nombre y genera tus credenciales de acceso.',
      ),
      StepData(
        '04',
        Icons.code_rounded,
        'Conecta tu proyecto',
        'Utiliza las credenciales desde tu lenguaje o cliente favorito.',
      ),
    ];

    return SectionContainer(
      child: Column(
        children: [
          // Encabezado reutilizable de la sección
          const SectionTitle(
            eyebrow: 'CÓMO FUNCIONA',
            title: 'De cero a tu primera conexión',
            subtitle:
                'Una experiencia sencilla para que puedas empezar en minutos.',
          ),
          const SizedBox(height: 45),

          // Contenedor responsivo para las 4 etapas
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              // 4 columnas en pantallas anchas (>900px), 2 en medianas (>580px) y 1 en móviles
              final itemWidth = width > 900
                  ? (width - 45) / 4
                  : width > 580
                      ? (width - 15) / 2
                      : width;

              return Wrap(
                spacing: 15,
                runSpacing: 30,
                children: steps
                    .map(
                      (step) => StepCard(
                        width: itemWidth,
                        data: step,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 40),

          // Botón de llamado a la acción al final del flujo
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Crear mi primera instancia'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 27,
                vertical: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
