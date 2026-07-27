import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';

/// Sección visual de Beneficios principales de Raft DB.
/// 
/// ¿Qué hace?: Agrupa y distribuye las 6 tarjetas de beneficios en una grilla responsiva.
/// ¿De dónde recibe datos?: Colección inmutable de instancias `BenefitData`.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye en LandingScreen (landing_page.dart).
class BenefitsSection extends StatelessWidget {
  const BenefitsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const benefits = [
      BenefitData(
        Icons.bolt_rounded,
        'Creación rápida',
        'Obtén una base de datos y sus credenciales en pocos pasos.',
        Color(0xFFFFB020),
      ),
      BenefitData(
        Icons.shield_rounded,
        'Acceso seguro',
        'Credenciales individuales y aislamiento entre instancias.',
        Color(0xFF0878D1),
      ),
      BenefitData(
        Icons.school_rounded,
        'Ideal para aprender',
        'Practica consultas, modelado, APIs, migraciones y conexiones.',
        Color(0xFF7047E8),
      ),
      BenefitData(
        Icons.construction_rounded,
        'Herramientas de prueba',
        'Valida conexiones y revisa el estado de todos tus servicios.',
        Color(0xFF0BB6B2),
      ),
      BenefitData(
        Icons.hub_rounded,
        'Múltiples motores',
        'Selecciona el motor que mejor se adapte a cada proyecto.',
        Color(0xFFEA4A61),
      ),
      BenefitData(
        Icons.dashboard_rounded,
        'Panel centralizado',
        'Administra instancias, credenciales y disponibilidad.',
        Color(0xFF19A85B),
      ),
    ];

    return SectionContainer(
      background: AppColors.deepNavy,
      child: Column(
        children: [
          const SectionTitle(
            eyebrow: 'BENEFICIOS',
            title: 'Todo lo necesario para comenzar',
            subtitle:
                'Olvídate de instalaciones complejas y concéntrate en aprender.',
            light: true,
          ),
          const SizedBox(height: 42),

          // LayoutBuilder para la cuadrícula responsiva
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
                    .map(
                      (item) => BenefitCard(
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
