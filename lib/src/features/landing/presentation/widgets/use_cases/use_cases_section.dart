import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/use_cases/use_case_card.dart';

/// Sección visual de Casos de Uso del proyecto.
/// 
/// ¿Qué hace?: Muestra las tarjetas orientadas a Estudiantes, Desarrolladores y Docentes en un contenedor blanco.
/// ¿De dónde recibe datos?: Lista interna de perfiles `cases`.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class UseCasesSection extends StatelessWidget {
  const UseCasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    const cases = [
      BenefitData(
        Icons.school_rounded,
        'Estudiantes',
        'Practica bases de datos sin instalar servidores ni configurar entornos.',
        Color(0xFF7047E8),
      ),
      BenefitData(
        Icons.code_rounded,
        'Desarrolladores',
        'Crea prototipos, valida integraciones y prueba tus APIs.',
        Color(0xFF0878D1),
      ),
      BenefitData(
        Icons.co_present_rounded,
        'Docentes',
        'Proporciona entornos consistentes para cursos y talleres.',
        Color(0xFF0BB6B2),
      ),
    ];

    return SectionContainer(
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'CASOS DE USO',
            title: 'Diseñado para aprender y experimentar',
            subtitle:
                'Una plataforma accesible para educación, desarrollo y pruebas.',
          ),
          const SizedBox(height: 42),

          // LayoutBuilder para 3 columnas en pantallas medianas/grandes
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 750
                  ? (constraints.maxWidth - 36) / 3
                  : constraints.maxWidth;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: cases
                    .map(
                      (item) => UseCaseCard(
                        width: cardWidth,
                        data: item,
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
