import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/node_data.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/infrastructure/node_metric.dart'; // Widget


class NodeCard extends StatelessWidget {
  const NodeCard({
    required this.width,
    required this.data,
    required this.onRestart,
    super.key,
  });

  final double width;
  final NodeData data;
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
              ColoredIcon(
                icon: Icons.dns_rounded,
                color: AppColors.blue,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      data.role,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: 'Saludable',
                color: data.statusColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              NodeMetric(label: 'CPU', value: data.cpu),
              NodeMetric(label: 'Memoria', value: data.memory),
              NodeMetric(label: 'Disco', value: data.disk),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('Reiniciar nodo'),
            ),
          ),
        ],
      ),
    );
  }
}
