import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/ai_workspace.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/information_row.dart'; // Widget


class AiWorkspaceCard extends StatelessWidget {
  const AiWorkspaceCard({
    required this.width,
    required this.workspace,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final double width;
  final AiWorkspace workspace;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              const ColoredIcon(
                icon: Icons.smart_toy_rounded,
                color: AppColors.purple,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workspace.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${workspace.provider} · ${workspace.model}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: workspace.active ? 'Activo' : 'Suspendido',
                color: workspace.active ? AppColors.green : AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 19),
          InformationRow(
            icon: Icons.person_outline_rounded,
            label: 'Propietario',
            value: workspace.owner,
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.bolt_rounded,
            label: 'Consumo',
            value:
                '${workspace.requestsUsed} / ${workspace.requestsLimit} req',
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.calendar_today_outlined,
            label: 'Creado',
            value: workspace.createdAt,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: workspace.usageRatio.clamp(0, 1),
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: workspace.usageRatio >= 0.9
                  ? AppColors.red
                  : AppColors.purple,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Inspeccionar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              IconButton.outlined(
                tooltip: workspace.active ? 'Suspender' : 'Reactivar',
                onPressed: onToggle,
                icon: Icon(
                  workspace.active
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 7),
              IconButton.outlined(
                tooltip: 'Eliminar',
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.red,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
