// ==========================================
// ¿Qué hace?: Renderiza el botón de alternancia de tema (Día/Noche) y los botones de autenticación (Login/Register).
// ¿De dónde trae datos?: Ingesta estado isDark y ref de Riverpod para alternar themeModeProvider.
// ¿Hacia dónde va / Cómo se conecta?: Invocado por NavigationBarSection en vista desktop.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';
import 'package:go_router/go_router.dart';

class NavActionButtons extends ConsumerWidget {
  const NavActionButtons({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Toggle Día / Noche
        IconButton(
          tooltip: isDark ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          icon: Icon(
            isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: isDark ? AppColors.warning : AppColors.dayPrimary,
          ),
        ),
        const SizedBox(width: 8),

        // Botón Iniciar sesión
        TextButton(
          onPressed: () => context.push('/login'),
          style: TextButton.styleFrom(
            foregroundColor: isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary,
          ),
          child: const Text('Iniciar sesión'),
        ),
        const SizedBox(width: 8),

        // Botón Crear cuenta
        FilledButton(
          onPressed: () => context.push('/register'),
          style: FilledButton.styleFrom(
            backgroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
            foregroundColor: isDark ? AppColors.nightBackground : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          ),
          child: const Text('Crear cuenta'),
        ),
      ],
    );
  }
}
