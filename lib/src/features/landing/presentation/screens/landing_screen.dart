import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/widgets/databases/database_section.dart';
import 'package:frontend_landing/src/features/landing/widgets/hero/hero_section.dart';
import 'package:frontend_landing/src/features/landing/widgets/navigation/navigation_bar_section.dart';

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
              DatabaseSection(),
              // A medida que modularicemos las 7 secciones restantes, las iremos integrando aquí
            ],
          ),
        ),
      ),
    );
  }
}

