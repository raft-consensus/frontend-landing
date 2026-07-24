import 'package:flutter/material.dart';

/// Badge tipo cápsula ("Pill") usado en el Hero para destacar etiquetas o público objetivo.
class Pill extends StatelessWidget {
  const Pill({
    required this.icon,
    required this.label,
    super.key,
  });

  /// Icono decorativo al inicio del badge.
  final IconData icon;

  /// Texto descriptivo en mayúsculas.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE4FAFA), // Fondo azul aguamarina muy suave
        borderRadius: BorderRadius.circular(30), // Bordes totalmente redondeados
        border: Border.all(color: const Color(0xFFB6EEEC)), // Borde sutil
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ajusta el ancho al contenido
        children: [
          Icon(icon, size: 17, color: const Color(0xFF008F91)),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF007D80),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
