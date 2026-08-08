import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/hero_image.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/mini_benefit.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/pill_badge.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/hero/wave_background.dart';
import 'package:go_router/go_router.dart';

/// ¿Qué hace?: Sección de bienvenida multiservicio de Raft Cloud con texto/CTA a la izquierda e imagen destacada a la derecha.
/// ¿De dónde trae datos?: Ingesta Pill, MiniBenefit, HeroImage y WaveBackground adaptables al tema.
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica como primer bloque de contenido en LandingPage.
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // Tema activo

    // Gradiente azul corporativo profundo para Modo Día y Medianoche para Modo Noche
    final bgGradient = LinearGradient(
      begin: Alignment.centerLeft, // Inicio horizontal (Izquierda - Texto)
      end: Alignment.centerRight, // Fin horizontal (Derecha - Balsa)
      colors: isDark
          ? [
              AppColors.nightBackground,
              AppColors.nightSurface,
              AppColors.nightBackground,
            ]
          : [
              const Color(
                0xFF0A2946,
              ), // Azul profundo y limpio a la izquierda (texto)
              const Color(0xFF0E4B82), // Azul marino medio
              const Color(
                0xFF186CC0,
              ), // Azul mar brillante e intenso a la derecha (coincide con la balsa)
            ],
    );

    // En Modo Día los textos del Hero se muestran en blanco luminoso sobre el fondo azul
    final titleColor = isDark ? AppColors.nightTextPrimary : Colors.white;
    final subtitleColor = isDark
        ? AppColors.nightTextSecondary
        : const Color(0xFFD4E6F8);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: bgGradient),
      child: Stack(
        children: [
          const Positioned.fill(
            child: Opacity(opacity: 0.25, child: WaveBackground()),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 75),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 850;

                    // Columna con los textos, botones y beneficios a la izquierda
                    final content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Pill(
                          icon: Icons.school_rounded,
                          label: 'PARA ESTUDIANTES Y DESARROLLADORES',
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Tu ecosistema cloud\ngratuito para\nconstruir.',
                          style: TextStyle(
                            fontSize: desktop ? 52 : 38,
                            fontWeight: FontWeight.w900,
                            color: titleColor,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 580),
                          child: Text(
                            'Despliega bases de datos, asigna subdominios DNS con SSL, '
                            'administra API Keys de IA y orquesta flujos con n8n en pocos minutos.',
                            style: TextStyle(
                              color: subtitleColor,
                              fontSize: 16,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        FilledButton.icon(
                          onPressed: () => context.push('/register'),
                          icon: const Icon(Icons.rocket_launch_rounded),
                          label: const Text('Comenzar gratis'),
                          // En hero_section.dart (Líneas 76 a 80):
                          style: FilledButton.styleFrom(
                            backgroundColor: isDark
                                ? AppColors.nightPrimary
                                : AppColors.cyan,
                            foregroundColor: isDark
                                ? AppColors.nightBackground
                                : AppColors.dayPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26,
                              vertical: 18,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            MiniBenefit('Sin tarjeta'),
                            MiniBenefit('4 servicios integrados'),
                            MiniBenefit('Entorno seguro'),
                          ],
                        ),
                      ],
                    );

                    if (!desktop) {
                      return Column(
                        children: [
                          content,
                          const SizedBox(height: 40),
                          const HeroImage(), // Imagen de balsa grande en vista móvil/tablet
                        ],
                      );
                    }

                    return Row(
                      children: [
                        Expanded(flex: 12, child: content),
                        const SizedBox(width: 40),
                        const Expanded(
                          flex: 10,
                          child: HeroImage(),
                        ), // Imagen de balsa grande en vista desktop
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
