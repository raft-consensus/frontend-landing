import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefits_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/database_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/faq/faq_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/final_cta/final_cta_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/footer/footer_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/hero_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/how_it_works_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/metrics/metrics_section.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/landing_drawer.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/navigation_bar_section.dart';

/// ¿Qué hace?: Pantalla principal de la Landing Page que ensambla las 8 secciones modularizadas de Raft Cloud.
/// ¿De dónde trae datos?: Ensambla HeroSection, MetricsSection, DatabaseSection, BenefitsSection, HowItWorksSection, FaqSection, FinalCtaSection y FooterSection.
/// ¿Hacia dónde va / Cómo se conecta?: Ruta pública raíz `/` configurada en app_router.dart.
class LandingPage extends StatelessWidget {
  LandingPage({super.key});

  // Llaves globales para desplazamiento por secciones
  final GlobalKey _metricsKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _benefitsKey = GlobalKey();
  final GlobalKey _howItWorksKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  // Controlador de scroll vertical
  final ScrollController _scrollController = ScrollController();

  /// Desplaza suavemente hasta la sección objetivo
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

  /// Desplaza de regreso hasta la parte superior de la página
  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // Tema activo

    return Scaffold(
      // Botón flotante para subir
      floatingActionButton: FloatingActionButton.small(
        onPressed: _scrollToTop,
        backgroundColor: isDark ? AppColors.nightCard : AppColors.dayPrimary,
        foregroundColor: Colors.white,
        tooltip: 'Volver arriba',
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),

      // Menú lateral móvil
      endDrawer: LandingDrawer(
        onMetricsTap: () => _scrollToSection(_metricsKey),
        onDatabasesTap: () => _scrollToSection(_servicesKey),
        onBenefitsTap: () => _scrollToSection(_benefitsKey),
        onHowItWorksTap: () => _scrollToSection(_howItWorksKey),
        onFaqTap: () => _scrollToSection(_faqKey),
      ),

      body: SelectionArea(
        child: Column(
          children: [
            // Navbar superior fijo
            NavigationBarSection(
              onLogoTap:
                  _scrollToTop, // Desplaza suavemente al inicio (HeroSection)
              onMetricsTap: () => _scrollToSection(_metricsKey),
              onDatabasesTap: () => _scrollToSection(_servicesKey),
              onBenefitsTap: () => _scrollToSection(_benefitsKey),
              onHowItWorksTap: () => _scrollToSection(_howItWorksKey),
              onFaqTap: () => _scrollToSection(_faqKey),
            ),

            // Contenido escroleable (8 secciones optimizadas)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    const HeroSection(),
                    MetricsSection(key: _metricsKey),
                    DatabaseSection(key: _servicesKey),
                    BenefitsSection(key: _benefitsKey),
                    HowItWorksSection(key: _howItWorksKey),
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
