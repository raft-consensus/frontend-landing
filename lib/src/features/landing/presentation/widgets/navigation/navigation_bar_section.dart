import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/nav_action_buttons.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/nav_links_group.dart';

/// ¿Qué hace?: Contenedor orquestador del Navbar dividido en 3 secciones en escritorio (Logo, Navegación, Tema/Auth).
/// ¿De dónde trae datos?: Ingesta callbacks de scroll desde LandingPage y escucha themeModeProvider vía Riverpod.
/// ¿Hacia dónde va / Cómo se conecta?: Se posiciona fijo en la parte superior de LandingPage.
class NavigationBarSection extends ConsumerWidget {
  const NavigationBarSection({
    this.onLogoTap, // Callback para scroll al inicio
    this.onMetricsTap,
    this.onDatabasesTap,
    this.onBenefitsTap,
    this.onHowItWorksTap,
    this.onFaqTap,
    super.key,
  });

  final VoidCallback? onLogoTap;
  final VoidCallback? onMetricsTap; // Callback scroll métricas
  final VoidCallback? onDatabasesTap; // Callback scroll servicios
  final VoidCallback? onBenefitsTap; // Callback scroll beneficios
  final VoidCallback? onHowItWorksTap; // Callback scroll cómo funciona
  final VoidCallback? onFaqTap; // Callback scroll FAQ

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark; // Tema activo
    final navBg = isDark
        ? AppColors.nightBackground.withValues(alpha: 0.95)
        : Colors.white.withValues(alpha: 0.96);

    return Container(
      color: navBg,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth > 950;

              return Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // 3 secciones distribuidas equitativamente
                children: [
                  // 1. Sección Izquierda: Logotipo de marca Raft Cloud clickeable
                  InkWell(
                    onTap: onLogoTap,
                    borderRadius: BorderRadius.circular(8),
                    child: const RaftLogo(),
                  ),

                  if (desktop) ...[
                    // 2. Sección Central: Enlaces de navegación de la página
                    NavLinksGroup(
                      onMetricsTap: onMetricsTap,
                      onDatabasesTap: onDatabasesTap,
                      onBenefitsTap: onBenefitsTap,
                      onHowItWorksTap: onHowItWorksTap,
                      onFaqTap: onFaqTap,
                    ),

                    // 3. Sección Derecha: Alternancia de Tema Día/Noche y Botones Auth
                    NavActionButtons(isDark: isDark),
                  ] else ...[
                    // Layout responsivo móvil (Toggle de tema y botón de menú drawer)
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => ref
                              .read(themeModeProvider.notifier)
                              .toggleTheme(),
                          icon: Icon(
                            isDark
                                ? Icons.light_mode_rounded
                                : Icons.dark_mode_rounded,
                            color: isDark
                                ? AppColors.warning
                                : AppColors.dayPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Builder(
                          builder: (scaffoldContext) => IconButton(
                            onPressed: () =>
                                Scaffold.of(scaffoldContext).openEndDrawer(),
                            icon: const Icon(Icons.menu_rounded),
                            color: isDark
                                ? AppColors.nightTextPrimary
                                : AppColors.dayPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
