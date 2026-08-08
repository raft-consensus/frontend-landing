// ==========================================
// ¿Qué hace?: Badge pill redondeado superior para destacar el antetítulo en la HeroSection.
// ¿De dónde trae datos?: Ingesta IconData y String label, adaptando los colores al tema Day/Night.
// ¿Hacia dónde va / Cómo se conecta?: Invocado al inicio del contenido en HeroSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class Pill extends StatelessWidget {
  const Pill({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta tema visual (Raft Day vs Raft Night)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Colores adaptables del badge
    // Colores adaptables del badge con alto contraste sobre el fondo azul
    final bg = isDark
        ? AppColors.nightCard
        : AppColors.cyan.withValues(alpha: 0.18);
    final fg = AppColors.cyan; // Turquesa luminoso visible en Modo Día y Noche
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? AppColors.nightBorder
              : AppColors.cyan.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: fg,
          ), // Icono representativo a la izquierda
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
