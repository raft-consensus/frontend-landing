import 'package:flutter/material.dart';

/// Elemento pequeño con un checkmark verde usado para listar ventajas inmediatas (ej. "Sin tarjeta").
class MiniBenefit extends StatelessWidget {
  const MiniBenefit(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Color(0xFF16AF74), // Verde de confirmación
          size: 19,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF40536A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
