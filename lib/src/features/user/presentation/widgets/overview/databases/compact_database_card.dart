// ==========================================
// Qué hace: Tarjeta compacta para representar una instancia de base de datos con logo del motor e iluminación hover.
// Dónde se conecta: Renderizado en OverviewDatabasesGrid.
// De dónde trae datos: Recibe la entidad DatabaseInstance y el callback onTap.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/status_badge.dart';

/// Tarjeta individual compacta de base de datos para la vista de resumen
class CompactDatabaseCard extends StatefulWidget {
  const CompactDatabaseCard({
    required this.instance, // Instancia de BD
    required this.onTap, // Callback al hacer clic
    super.key,
  });

  final DatabaseInstance instance;
  final VoidCallback onTap;

  @override
  State<CompactDatabaseCard> createState() => _CompactDatabaseCardState();
}

class _CompactDatabaseCardState extends State<CompactDatabaseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(widget.instance.engine);
    final engineColor = AppTheme.getEngineColor(
      widget.instance.engine,
      Theme.of(context).brightness,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final hoverBg = isDark ? const Color(0xFF1B2D42) : const Color(0xFFEDF4FC);

    final defaultBorder = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final hoverBorder = engineColor.withValues(alpha: 0.50);

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered ? hoverBorder : defaultBorder,
            width: 1.0,
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: engineColor.withValues(alpha: 0.10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // 1. Franja lateral de color de marca
                Container(
                  width: 4,
                  height: 36,
                  decoration: BoxDecoration(
                    color: engineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),

                // 2. Icono oficial del motor
                EngineIcon(
                  engineName: widget.instance.engine,
                  icon: style.icon,
                  color: engineColor,
                  small: false,
                ),
                const SizedBox(width: 12),

                // 3. Nombre y versión
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.instance.name,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.instance.engine} v${widget.instance.version}',
                        style: TextStyle(
                          color: subtitleColor,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // 4. Badge de estado
                StatusBadge(running: widget.instance.isRunning),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
