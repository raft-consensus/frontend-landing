// ==========================================
// Qué hace: Botón interactivo para alternar entre el tema Raft Day y Raft Night.
// Dónde se conecta: Consumido por DashboardTopbar.
// De dónde trae datos: Escucha y modifica themeModeProvider vía Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';

/// Botón selector de tema visual
class TopbarThemeToggle extends ConsumerWidget {
  const TopbarThemeToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return IconButton(
      onPressed: () {
        ref.read(themeModeProvider.notifier).toggleTheme();
      },
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: iconColor,
      ),
      tooltip: isDark
          ? 'Cambiar a Modo Claro (Raft Day)'
          : 'Cambiar a Modo Oscuro (Raft Night)',
    );
  }
}
