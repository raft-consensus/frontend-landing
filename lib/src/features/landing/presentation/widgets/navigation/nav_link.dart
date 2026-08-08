import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Componente de enlace para las opciones de menú en la barra de navegación superior con soporte Day/Night.
/// ¿De dónde trae datos?: Ingesta la etiqueta String y el callback opcional onTap.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado en NavLinksGroup dentro de NavigationBarSection.
class NavLink extends StatelessWidget {
  const NavLink(this.label, {this.onTap, super.key});

  final String label; // Texto descriptivo del enlace
  final VoidCallback? onTap; // Evento al presionar

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo
    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary; // Color del texto dinámico

    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 13),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
