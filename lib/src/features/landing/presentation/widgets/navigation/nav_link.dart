import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de enlace para las opciones de menú en la barra de navegación superior.
class NavLink extends StatelessWidget {
  const NavLink(this.label, {super.key});

  /// Texto descriptivo que se mostrará en el botón de navegación.
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      // Acción al presionar el enlace (puedes vincular un scroll o navegación aquí)
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: AppColors.navy, // Color del texto al interactuar
        padding: const EdgeInsets.symmetric(horizontal: 13), // Padding lateral
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600, // Fuente semi-negrita para legibilidad
        ),
      ),
    );
  }
}
