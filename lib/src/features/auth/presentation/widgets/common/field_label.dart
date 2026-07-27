import 'package:flutter/material.dart';

/// Etiqueta estándar colocada sobre los campos de entrada de texto de autenticación.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  /// Texto de la etiqueta (ej. "Correo electrónico").
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF10233F),
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
