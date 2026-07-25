import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefits_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/dashboard/dashboard_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/database_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/faq/faq_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/final_cta/final_cta_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/hero_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/how_it_works_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metrics_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/navigation_bar_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/use_cases/use_cases_section.dart';

/// Pantalla principal de la Landing Page que ensambla las secciones modularizadas.
class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SelectionArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              NavigationBarSection(),
              HeroSection(),
              MetricsSection(),
              DatabaseSection(),
              BenefitsSection(),
              HowItWorksSection(),
              DashboardSection(),
              UseCasesSection(),
              FaqSection(),
              FinalCtaSection(),
              FooterSection(),
              // A medida que modularicemos las 7 secciones restantes, las iremos integrando aquí
            ],
          ),
        ),
      ),
    );
  }
}

