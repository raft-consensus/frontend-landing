import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/information_row.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/engine_style.dart'; // Widget


class ManagedDatabaseCard extends StatelessWidget {
  const ManagedDatabaseCard({
    required this.width,
    required this.database,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    required this.onRestart,
    super.key,
  });

  final double width;
  final ManagedDatabase database;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(database.engine);

    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              ColoredIcon(icon: style.icon, color: style.color),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      database.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${database.engine} · ${database.host}',
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
                label: database.running ? 'Activa' : 'Detenida',
                color: database.running
                    ? AppColors.green
                    : AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 19),
          InformationRow(
            icon: Icons.person_outline_rounded,
            label: 'Propietario',
            value: database.owner,
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.data_usage_rounded,
            label: 'Almacenamiento',
            value: '${database.storageMb.toStringAsFixed(0)} MB',
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.calendar_today_outlined,
            label: 'Creada',
            value: database.createdAt,
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
                tooltip: database.running ? 'Detener' : 'Iniciar',
                onPressed: onToggle,
                icon: Icon(
                  database.running
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
