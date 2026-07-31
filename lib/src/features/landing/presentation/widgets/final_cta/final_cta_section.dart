import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

/// Sección de llamado a la acción final (Final CTA).
/// 
/// ¿Qué hace?: Renderiza un banner curvo con gradiente azul, iconos y botones para iniciar o ver la documentación.
/// ¿De dónde recibe datos?: Componente estático con botones interactivos.
/// ¿Hacia dónde va / Dónde se conecta?: Se incluye directamente en LandingScreen (landing_page.dart).
class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 65,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.navy, Color(0xFF075DA2)],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                // Icono representativo de Raft
                const Icon(
                  Icons.sailing_rounded,
                  color: AppColors.cyan,
                  size: 56,
                ),
                const SizedBox(height: 18),

                // Título de llamado a la acción
                const Text(
                  'Lleva tu próximo proyecto a flote',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 15),

                // Subtítulo
                const Text(
                  'Crea una base de datos gratuita y empieza a construir en minutos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFC7D7EA),
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 28),

                // Botones principales de interacción
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => context.push('/register'),
                      icon: const Icon(Icons.rocket_launch_rounded),
                      label: const Text('Comenzar gratis'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: AppColors.navy,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                      ),
                    ),
                    // OutlinedButton(
                    //   onPressed: () {}, // pendiente
                    //   style: OutlinedButton.styleFrom(
                    //     foregroundColor: Colors.white,
                    //     side: const BorderSide(color: Colors.white54),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 26,
                    //       vertical: 20,
                    //     ),
                    //   ),
                    //   child: const Text('Ver documentación'),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
