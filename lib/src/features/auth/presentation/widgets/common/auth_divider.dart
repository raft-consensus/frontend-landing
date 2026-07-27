import 'package:flutter/material.dart';

/// Línea divisora horizontal con texto central para separar el acceso social del formulario con correo.
class AuthDivider extends StatelessWidget {
  const AuthDivider({required this.label, super.key});

  /// Texto central del divisor.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFDDE6F0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF687A91),
              fontSize: 12,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFDDE6F0))),
      ],
    );
  }
}
