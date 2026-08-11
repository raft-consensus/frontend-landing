// ==========================================
// Qué hace: Renderiza la sección de consumo total acumulado de almacenamiento con su icono y barra de progreso.
// Dónde se conecta: Importado por DatabaseSummaryCard.
// De dónde recibe datos: Recibe totalUsedBytes, totalLimitBytes, progress y percentage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/core/utils/storage_formatter.dart'; // Core

/// Sección modular del consumo acumulado global de disco duro con indicador de progreso
class SummaryStorageSection extends StatelessWidget {
  const SummaryStorageSection({
    required this.totalUsedBytes,  // Bytes totales acumulados consumidos por el usuario
    required this.totalLimitBytes, // Bytes totales máximos de la cuota asignada
    required this.progress,        // Porcentaje normalizado entre 0.0 y 1.0
    required this.percentage,      // Porcentaje entero (0 a 100)
    super.key,
  });

  final int totalUsedBytes;
  final int totalLimitBytes;
  final double progress;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Icono destacado de tarjeta SD/Almacenamiento
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.sd_storage_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Consumo Total de Almacenamiento',
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${StorageFormatter.formatBytes(totalUsedBytes)} / ${StorageFormatter.formatBytes(totalLimitBytes > 0 ? totalLimitBytes : 251658240)} ($percentage%)',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Barra de progreso global con color dinámico por umbral
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: theme.dividerColor.withValues(
              alpha: isDark ? 0.30 : 0.50,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 85
                  ? AppColors.error
                  : (percentage >= 70
                        ? AppColors.warning
                        : theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
