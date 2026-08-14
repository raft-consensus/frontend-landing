// ==========================================
// Qué hace: Tarjeta de historial de actividad reciente desacoplada y reactiva mediante Riverpod.
// Dónde se conecta: Renderizado en el panel derecho de la sección media de OverviewPage.
// De dónde trae datos: Escucha userActivityProvider vía Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_activity_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/services/activity_item_row.dart';

/// Tarjeta de historial de actividad reciente del usuario
class ActivitySectionCard extends ConsumerWidget {
  const ActivitySectionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ref.watch(userActivityProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      height: 300, // Altura estándar fija para evitar overflow
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Cabecera
          Row(
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
          ),
          const SizedBox(height: 14),

          // 2. Lista desplazable de actividades
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
                      return ActivityItemRow(
                        activity: activities[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
