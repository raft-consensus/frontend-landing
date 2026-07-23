import 'package:flutter/material.dart';

/// Botón con borde e icono personalizado para inicio de sesión / registro social (Google, GitHub).
class SocialButton extends StatelessWidget {
  const SocialButton({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.onPressed,
    super.key,
  });

  /// Nombre del proveedor (ej. "Google").
  final String label;

  /// Icono representativo del proveedor.
  final IconData icon;

  /// Color distintivo del icono.
  final Color iconColor;

  /// Callback al presionar el botón.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: iconColor, size: 24),
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF10233F),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        side: const BorderSide(color: Color(0xFFDDE6F0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
