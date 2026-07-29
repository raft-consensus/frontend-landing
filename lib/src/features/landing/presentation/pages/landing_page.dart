import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefits_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/dashboard/dashboard_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/database_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/faq/faq_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/final_cta/final_cta_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/hero_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/how_it_works_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metrics_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/landing_drawer.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/navigation_bar_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/use_cases/use_cases_section.dart';

/// Pantalla principal de la Landing Page que ensambla las secciones modularizadas y coordina el scroll.
class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  // Llaves globales para ubicar la posición vertical de cada sección
  final GlobalKey _metricsKey = GlobalKey();
  final GlobalKey _databasesKey = GlobalKey();
  final GlobalKey _benefitsKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  // Controlador que rastrea y maneja la posición vertical del scroll
  final ScrollController _scrollController = ScrollController();

  /// Función auxiliar que desplaza la pantalla suavemente hasta el widget de la llave pasada
  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  /// Función que desplaza la pantalla suavemente de regreso hasta la parte superior (Navbar)
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Botón flotante pequeño en la esquina inferior derecha
      floatingActionButton: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
        tooltip: 'Volver arriba',
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
      // Menú desplegable lateral para pantallas móviles / tablets
      endDrawer: LandingDrawer(
        onMetricsTap: () => _scrollToSection(_metricsKey),
        onDatabasesTap: () => _scrollToSection(_databasesKey),
        onBenefitsTap: () => _scrollToSection(_benefitsKey),
        onHowItWorksTap: () => _scrollToSection(_howItWorksKey),
        onFaqTap: () => _scrollToSection(_faqKey),
      ),
      body: SelectionArea(
        child: Column(
          children: [
            // 1. Navbar FIJO en la parte superior
            NavigationBarSection(
              onMetricsTap: () => _scrollToSection(_metricsKey),
              onDatabasesTap: () => _scrollToSection(_databasesKey),
              onBenefitsTap: () => _scrollToSection(_benefitsKey),
              onHowItWorksTap: () => _scrollToSection(_howItWorksKey),
              onFaqTap: () => _scrollToSection(_faqKey),
            ),
            // 2. Contenido desplazable debajo del Navbar
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const HeroSection(),
                    MetricsSection(key: _metricsKey),
                    DatabaseSection(key: _databasesKey),
                    BenefitsSection(key: _benefitsKey),
                    HowItWorksSection(key: _howItWorksKey),
                    const DashboardSection(),
                    const UseCasesSection(),
                    FaqSection(key: _faqKey),
                    const FinalCtaSection(),
                    const FooterSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
