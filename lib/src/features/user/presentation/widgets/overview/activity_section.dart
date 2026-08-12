// ==========================================
// Qué hace: Muestra el historial scrollable de actividad reciente desacoplado y reactivo mediante Riverpod.
// De dónde recibe datos: Escucha userActivityProvider para renderizar las actividades del usuario y Theme.of(context) para colores.
// Hacia dónde se conecta: Ubicado en el panel derecho de la sección central en OverviewPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_activity_provider.dart';

/// Widget reactivo que renderiza la tarjeta de actividad reciente adaptándose dinámicamente a la altura de su contenedor
class ActivitySection extends ConsumerWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Obtiene la lista dinámica de actividades vivas desde el proveedor
    final activities = ref.watch(userActivityProvider);

    // 2. Detecta la luminosidad del tema activo (Día vs Noche)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 3. Colores dinámicos del contenedor
    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final titleColor = isDark
        ? AppColors.nightTextPrimary
        : AppColors.dayTextPrimary;
    final subtitleColor = isDark
        ? AppColors.nightTextSecondary
        : AppColors.dayTextSecondary;

    return Container(
      // Se removió el height: 285 para nivelar la altura con EcosystemServicesCard mediante IntrinsicHeight
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-widget 1: Cabecera "Actividad Reciente"
          _ActivityHeader(titleColor: titleColor, isDark: isDark),
          const SizedBox(height: 14),

          // Sub-widget 2: Lista scrollable interna de registros de actividad
          Expanded(
            child: activities.isEmpty
                ? Center(
                    child: Text(
                      'No hay actividad reciente registrada.',
                      style: TextStyle(color: subtitleColor, fontSize: 12),
                    ),
                  )
                : ListView.separated(
                    itemCount: activities.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 12,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    itemBuilder: (context, index) {
                      final activity = activities[index];
                      return _ActivityItemRow(
                        activity: activity,
                        titleColor: titleColor,
                        subtitleColor: subtitleColor,
                        isDark: isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Sub-widget privado 1: Cabecera con título e icono de reloj
class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.titleColor, required this.isDark});

  final Color titleColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Actividad Reciente',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.history_rounded,
          size: 20,
          color: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
        ),
      ],
    );
  }
}

/// Sub-widget privado 2: Fila individual con resplandor hover sutil y cursor estándar
class _ActivityItemRow extends StatefulWidget {
  const _ActivityItemRow({
    required this.activity,
    required this.titleColor,
    required this.subtitleColor,
    required this.isDark,
  });

  final UserActivityItem activity;
  final Color titleColor;
  final Color subtitleColor;
  final bool isDark;

  @override
  State<_ActivityItemRow> createState() => _ActivityItemRowState();
}

class _ActivityItemRowState extends State<_ActivityItemRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverBg = widget.isDark
        ? Colors.white.withValues(alpha: 0.03)
        : Colors.black.withValues(alpha: 0.03);

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
            // Icono representativo con el color del evento
            Icon(
              widget.activity.icon,
              color: widget.activity.getColor(widget.isDark),
              size: 18,
            ),
            const SizedBox(width: 10),

            // Textos del evento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: TextStyle(
                      color: widget.titleColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.activity.desc,
                    style: TextStyle(color: widget.subtitleColor, fontSize: 11),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.activity.time,
                    style: TextStyle(
                      color: widget.subtitleColor.withValues(alpha: 0.7),
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
