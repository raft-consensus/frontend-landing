// ==========================================
// Qué hace: Renderiza la píldora de estado reactiva ("Activa" en verde o "Revocada" en rojo).
// Dónde se conecta: Consumido por AiKeyRowItem.
// De dónde trae datos: Recibe el parámetro status de la entidad AiKey.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// Badge reactivo de estado para la API Key (Activa / Revocada)
class AiKeyStatusBadge extends StatelessWidget {
  const AiKeyStatusBadge({required this.status, super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final isActive = status.toLowerCase() == 'active';
    final badgeColor = isActive ? AppColors.success : AppColors.error;
    final label = isActive ? 'Activa' : 'Revocada';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: badgeColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
