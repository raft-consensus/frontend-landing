import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de viñeta con check verde para destacar características del Dashboard.
/// 
/// ¿Qué hace?: Renderiza un círculo verde claro con un icono de check y el texto descriptivo.
/// ¿De dónde recibe datos?: String label con la característica a resaltar.
/// ¿Hacia dónde va / Dónde se conecta?: Renderizado en el lado izquierdo de DashboardSection.
class DashboardFeature extends StatelessWidget {
  const DashboardFeature(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 27,
            height: 27,
            decoration: const BoxDecoration(
              color: Color(0xFFD9F6ED),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_rounded,
              color: Color(0xFF13A46E),
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
