import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/auth/presentation/screens/register_screen.dart';
import 'package:frontend_landing/src/features/landing/widgets/hero/mini_benefit.dart';
import 'package:frontend_landing/src/features/landing/widgets/hero/pill_badge.dart';
import 'package:frontend_landing/src/features/landing/widgets/hero/raft_illustration.dart';
import 'package:frontend_landing/src/features/landing/widgets/hero/wave_background.dart';
import 'package:go_router/go_router.dart';

/// Sección principal de bienvenida (Hero Section).
class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF2FCFF), Color(0xFFEAF4FF)],
        ),
      ),
      child: Stack(
        children: [
          // Fondo de olas sutiles
          const Positioned.fill(
            child: Opacity(opacity: 0.22, child: WaveBackground()),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 72, 24, 90),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final desktop = constraints.maxWidth > 850;

                    // Columna con los textos, botones y beneficios de la izquierda
                    final content = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Pill(
                          icon: Icons.school_rounded,
                          label: 'PARA ESTUDIANTES Y DESARROLLADORES',
                        ),
                        const SizedBox(height: 25),
                        Text(
                          'Bases de datos\ngratuitas para\nconstruir.',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(fontSize: desktop ? 58 : 42),
                        ),
                        const SizedBox(height: 22),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 590),
                          child: const Text(
                            'Despliega MySQL, PostgreSQL, SQL Server y '
                            'MongoDB en pocos minutos. Practica, prueba y '
                            'conecta tus proyectos sin configuraciones complejas.',
                            style: TextStyle(
                              color: Color(0xFF52647C),
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Botones de acción principales
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () => context.go('/register'),
                              icon: const Icon(Icons.rocket_launch_rounded),
                              label: const Text('Crear base de datos gratis'),
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                              ),
                            ),

                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.play_circle_outline),
                              label: const Text('Cómo funciona'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.navy,
                                side: const BorderSide(
                                  color: Color(0xFFBCCCE0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 27),
                        // Beneficios rápidos
                        const Wrap(
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            MiniBenefit('Sin tarjeta'),
                            MiniBenefit('Configuración rápida'),
                            MiniBenefit('Entorno seguro'),
                          ],
                        ),
                      ],
                    );

                    // Si es móvil/tablet pequeña: apila texto arriba e ilustración abajo
                    if (!desktop) {
                      return Column(
                        children: [
                          content,
                          const SizedBox(height: 50),
                          const RaftIllustration(),
                        ],
                      );
                    }

                    // Si es escritorio: muestra texto a la izquierda e ilustración a la derecha
                    return Row(
                      children: [
                        Expanded(flex: 11, child: content),
                        const SizedBox(width: 50),
                        const Expanded(flex: 9, child: RaftIllustration()),
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
