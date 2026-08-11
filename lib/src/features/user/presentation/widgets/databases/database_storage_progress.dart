// ==========================================
// Qué hace: Renderiza la barra gráfica de consumo de almacenamiento con formateo dinámico y colores por umbral.
// Dónde se conecta: Importado por DatabaseManagementCard.
// De dónde recibe datos: Recibe la entidad DatabaseInstance y el color base del motor.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/core/utils/storage_formatter.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain

/// Barra gráfica de progreso de almacenamiento con colores según el nivel de ocupación
class DatabaseStorageProgress extends StatelessWidget {
  const DatabaseStorageProgress({
    required this.instance,    // Instancia con bytes ocupados y máxima capacidad
    required this.engineColor, // Color primario asignado al motor
    super.key,
  });

  final DatabaseInstance instance;
  final Color engineColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    // Cálculo de progreso exacto en Bytes y formateo dinámico (B, KB, MB, GB)
    final usedFormatted = StorageFormatter.formatBytes(instance.usedSpaceBytes);
    final limitFormatted = StorageFormatter.formatBytes(instance.maxSpaceBytes);
    final double progress = instance.maxSpaceBytes > 0
        ? (instance.usedSpaceBytes / instance.maxSpaceBytes).clamp(0.0, 1.0)
        : 0.0;
    final int percentage = (progress * 100).toInt();

    // Selección de color de la barra según el umbral (< 70% motor, >= 70% amarillo, > 85% rojo)
    final Color barColor = percentage > 85
        ? AppColors.error
        : (percentage >= 70 ? AppColors.warning : engineColor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Almacenamiento ocupado',
              style: TextStyle(color: subtitleColor, fontSize: 11),
            ),
            Text(
              '$usedFormatted / $limitFormatted', // Texto dinámico ej: "40.0 KB / 20.0 MB"
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.w800,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.dividerColor.withValues(
              alpha: isDark ? 0.30 : 0.50,
            ),
            valueColor: AlwaysStoppedAnimation<Color>(barColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
