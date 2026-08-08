// ==========================================
// Archivo: lib/src/features/landing/presentation/widgets/navigation/drawer_nav_tiles.dart
// ¿Qué hace?: Renderiza el listado vertical de opciones de navegación con iconos y la alternancia de tema.
// ¿De dónde trae datos?: Ingesta callbacks de scroll, color primario y estado isDark.
// ¿Hacia dónde va / Cómo se conecta?: Invocado dentro de LandingDrawer.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';

class DrawerNavTiles extends ConsumerWidget {
  const DrawerNavTiles({
    required this.primaryColor,
    required this.isDark,
    this.onMetricsTap,
    this.onDatabasesTap,
    this.onBenefitsTap,
    this.onHowItWorksTap,
    this.onFaqTap,
    super.key,
  });

  final Color primaryColor;
  final bool isDark;
  final VoidCallback? onMetricsTap;
  final VoidCallback? onDatabasesTap;
  final VoidCallback? onBenefitsTap;
  final VoidCallback? onHowItWorksTap;
  final VoidCallback? onFaqTap;

  void _navigate(BuildContext context, VoidCallback? callback) {
    Navigator.pop(context);
    callback?.call();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.bar_chart_rounded, color: primaryColor),
          title: const Text('Métricas'),
          onTap: () => _navigate(context, onMetricsTap),
        ),
        ListTile(
          leading: Icon(Icons.hub_rounded, color: primaryColor),
          title: const Text('Servicios'),
          onTap: () => _navigate(context, onDatabasesTap),
        ),
        ListTile(
          leading: Icon(Icons.star_outline_rounded, color: primaryColor),
          title: const Text('Beneficios'),
          onTap: () => _navigate(context, onBenefitsTap),
        ),
        ListTile(
          leading: Icon(Icons.route_rounded, color: primaryColor),
          title: const Text('Cómo funciona'),
          onTap: () => _navigate(context, onHowItWorksTap),
        ),
        ListTile(
          leading: Icon(Icons.help_outline_rounded, color: primaryColor),
          title: const Text('FAQ'),
          onTap: () => _navigate(context, onFaqTap),
        ),
        ListTile(
          leading: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? AppColors.warning : primaryColor,
          ),
          title: Text(isDark ? 'Modo Claro' : 'Modo Oscuro'),
          onTap: () => ref.read(themeModeProvider.notifier).toggleTheme(),
        ),
      ],
    );
  }
}
