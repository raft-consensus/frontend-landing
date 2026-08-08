import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';

/// ¿Qué hace?: Barra visual de progreso que indica las solicitudes consumidas vs el límite.
/// ¿De dónde trae datos?: Ingesta la entidad AiKey.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido por AiKeyRowItem.
class AiKeyMeterBar extends StatelessWidget {
  const AiKeyMeterBar({required this.item, super.key});

  final AiKey item;

  Color _getMeterColor(double percentage) {
    if (percentage >= 0.90) return AppColors.error;
    if (percentage >= 0.70) return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final meterColor = _getMeterColor(item.usagePercentage);
    final percentText = '${(item.usagePercentage * 100).toInt()}%';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Consumo: ${item.requestsUsed} / ${item.requestsLimit} reqs', style: TextStyle(fontSize: 11, color: labelColor)),
            Text(percentText, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: meterColor)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: item.usagePercentage,
            backgroundColor: meterColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(meterColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
