import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Elemento de viñeta para destacar características de Raft DB en el panel de registro.
class FeatureItem extends StatelessWidget {
  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  /// Icono descriptivo de la característica.
  final IconData icon;

  /// Título en negrita de la viñeta.
  final String title;

  /// Descripción corta.
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Caja translúcida con icono Cyan
        Container(
          width: 47,
          height: 47,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 23),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF91A5BF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
