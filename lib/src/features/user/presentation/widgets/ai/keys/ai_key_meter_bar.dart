// ==========================================
// Qué hace: Muestra el resumen de métricas de consumo de tokens y peticiones HTTP por clave.
// Dónde se conecta: Consumido por AiKeyRowItem.
// De dónde trae datos: Recibe la entidad AiKey.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain

/// Resumen numérico de métricas por API Key (Peticiones y Tokens acumulados)
class AiKeyMeterBar extends StatelessWidget {
  const AiKeyMeterBar({required this.item, super.key});

  final AiKey item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${item.totalRequests} reqs',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor),
            ),
            Text(
              '${item.totalTokens} tokens',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          item.lastUsedAt != null
              ? 'Último uso: ${item.lastUsedAt}'
              : 'Sin uso aún',
          style: TextStyle(fontSize: 11, color: labelColor),
        ),
      ],
    );
  }
}
