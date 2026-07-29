import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de enlace para las opciones de menú en la barra de navegación superior.
/// 
/// ¿Qué hace?: Renderiza un botón plano de texto con respuesta a clics.
/// ¿De dónde recibe datos?: String label y el evento opcional onTap.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado en NavigationBarSection.
class NavLink extends StatelessWidget {
  const NavLink(this.label, {this.onTap, super.key});

  /// Texto descriptivo que se mostrará en el botón de navegación.
  final String label;

  /// Callback que se dispara al presionar el enlace (ej: scroll a sección)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.navy,
        padding: const EdgeInsets.symmetric(horizontal: 13),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
