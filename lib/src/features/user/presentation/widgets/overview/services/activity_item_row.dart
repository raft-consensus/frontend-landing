// ==========================================
// Qué hace: Fila individual de evento de actividad reciente con icono representativo, descripción y tiempo.
// Dónde se conecta: Consumido dentro de ActivitySectionCard.
// De dónde trae datos: Recibe el modelo UserActivityItem.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_activity_provider.dart';

/// Fila individual de actividad reciente
class ActivityItemRow extends StatefulWidget {
  const ActivityItemRow({
    required this.activity, // Evento de actividad
    super.key,
  });

  final UserActivityItem activity;

  @override
  State<ActivityItemRow> createState() => _ActivityItemRowState();
}

class _ActivityItemRowState extends State<ActivityItemRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hoverBg = isDark
        ? Colors.white.withValues(alpha: 0.03)
        : Colors.black.withValues(alpha: 0.03);

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Icono del evento
            Icon(
              widget.activity.icon,
              color: widget.activity.getColor(isDark),
              size: 18,
            ),
            const SizedBox(width: 10),

            // 2. Textos del evento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.activity.desc,
                    style: TextStyle(color: subtitleColor, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.activity.time,
                    style: TextStyle(
                      color: subtitleColor.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
