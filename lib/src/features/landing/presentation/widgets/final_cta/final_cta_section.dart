// ==========================================
// ¿Qué hace?: Banner de llamado a la acción final (Final CTA) multiservicio con gradiente azul y soporte Day/Night.
// ¿De dónde trae datos?: Componente estático con botones interactivos de navegación.
// ¿Hacia dónde va / Cómo se conecta?: Se incluye directamente antes del Footer en LandingPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class FinalCtaSection extends StatelessWidget {
  const FinalCtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final containerBg = isDark ? AppColors.nightBackground : Colors.white;

    return Container(
      color: containerBg,
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
              gradient: LinearGradient(
                colors: isDark
                    ? [AppColors.nightSurface, AppColors.nightCard]
                    : [AppColors.dayPrimary, const Color(0xFF075DA2)],
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                // Icono representativo de Raft Cloud
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

                // Subtítulo multiservicio
                const Text(
                  'Explora bases de datos, DNS, IA y automatización. Gratis.',
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
                        foregroundColor: AppColors.dayPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 26,
                          vertical: 20,
                        ),
                      ),
                    ),
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
