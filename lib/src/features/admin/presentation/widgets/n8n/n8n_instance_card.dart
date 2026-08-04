import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/n8n_instance.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/information_row.dart'; // Widget


class N8nInstanceCard extends StatelessWidget {
  const N8nInstanceCard({
    required this.width,
    required this.instance,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    required this.onRestart,
    super.key,
  });

  final double width;
  final N8nInstance instance;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onRestart;

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
                icon: Icons.hub_rounded,
                color: AppColors.cyan,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instance.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      instance.host,
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
                label: instance.running ? 'Activa' : 'Detenida',
                color: instance.running ? AppColors.green : AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 19),
          InformationRow(
            icon: Icons.person_outline_rounded,
            label: 'Propietario',
            value: instance.owner,
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.account_tree_outlined,
            label: 'Workflows',
            value: '${instance.workflows}',
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.play_arrow_rounded,
            label: 'Ejecuciones (30d)',
            value: '${instance.executions30d}',
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.calendar_today_outlined,
            label: 'Creada',
            value: instance.createdAt,
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
                tooltip: 'Reiniciar',
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
              const SizedBox(width: 7),
              IconButton.outlined(
                tooltip: instance.running ? 'Detener' : 'Iniciar',
                onPressed: onToggle,
                icon: Icon(
                  instance.running
                      ? Icons.stop_circle_outlined
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
