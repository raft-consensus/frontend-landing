import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/nav_link.dart';
import 'package:go_router/go_router.dart';

/// Barra de navegación superior (Header/Navbar) con comportamiento responsivo.
///
/// ¿Qué hace?: Muestra el logotipo, los enlaces a secciones con scroll y los botones de autenticación.
/// ¿De dónde recibe datos?: Callbacks de scroll enviados desde LandingScreen.
/// ¿Hacia dónde va / Dónde se conecta?: Incluido al inicio de LandingScreen (landing_page.dart).
class NavigationBarSection extends StatelessWidget {
  const NavigationBarSection({
    this.onMetricsTap,
    this.onDatabasesTap,
    this.onBenefitsTap,
    this.onHowItWorksTap,
    this.onFaqTap,
    super.key,
  });

  final VoidCallback? onMetricsTap;
  final VoidCallback? onDatabasesTap;
  final VoidCallback? onBenefitsTap;
  final VoidCallback? onHowItWorksTap;
  final VoidCallback? onFaqTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.96),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 950;

              return Row(
                children: [
                  const RaftLogo(),
                  const Spacer(),
                  if (desktop) ...[
                    NavLink('Métricas', onTap: onMetricsTap),
                    NavLink('Bases de datos', onTap: onDatabasesTap),
                    NavLink('Beneficios', onTap: onBenefitsTap),
                    NavLink('Cómo funciona', onTap: onHowItWorksTap),
                    NavLink('FAQ', onTap: onFaqTap),
                    const SizedBox(width: 16),

                    // Botón secundario para Iniciar sesión (con .go como indicaste)
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Iniciar sesión'),
                    ),

                    const SizedBox(width: 8),

                    // Botón primario para Crear cuenta (con .go como indicaste)
                    FilledButton(
                      onPressed: () => context.go('/register'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                      ),
                      child: const Text('Crear cuenta'),
                    ),
                  ] 
                  else
                    Builder(
                      builder: (scaffoldContext) {
                        return IconButton(
                          onPressed: () =>
                              Scaffold.of(scaffoldContext).openEndDrawer(),
                          icon: const Icon(Icons.menu_rounded),
                          color: AppColors.navy,
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
