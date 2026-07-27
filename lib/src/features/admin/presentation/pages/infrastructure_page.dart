import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/node_data.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/infrastructure/infrastructure_metric.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/infrastructure/node_card.dart'; // Widget

class InfrastructurePage extends StatelessWidget {
  const InfrastructurePage({
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    const nodes = [
      NodeData(
        'raft-node-01',
        'Base de datos',
        '12%',
        '38%',
        '1.4 GB',
        AppColors.green,
      ),
      NodeData(
        'raft-node-02',
        'Base de datos',
        '28%',
        '54%',
        '2.1 GB',
        AppColors.green,
      ),
      NodeData(
        'raft-node-03',
        'API y autenticación',
        '44%',
        '61%',
        '1.8 GB',
        AppColors.orange,
      ),
      NodeData(
        'raft-backup-01',
        'Copias de seguridad',
        '8%',
        '24%',
        '8.6 GB',
        AppColors.green,
      ),
    ];

    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Infraestructura',
            subtitle:
                'Supervisa los nodos, recursos y servicios internos.',
            action: 'Actualizar métricas',
            actionIcon: Icons.refresh_rounded,
            onAction: () => onMessage(
              'Las métricas fueron actualizadas.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          if (maintenanceMode) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E7),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFFDF9D),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.construction_rounded,
                    color: AppColors.orange,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'El modo mantenimiento está activo. Los usuarios '
                      'tienen acceso restringido a la plataforma.',
                      style: TextStyle(
                        color: Color(0xFF74531D),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1000
                  ? (width - 54) / 4
                  : width >= 600
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'CPU promedio',
                    value: '23%',
                    icon: Icons.memory_rounded,
                    color: AppColors.blue,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Memoria utilizada',
                    value: '47%',
                    icon: Icons.developer_board_rounded,
                    color: AppColors.purple,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Disco utilizado',
                    value: '4.2 TB',
                    icon: Icons.circle_rounded,
                    color: AppColors.orange,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Tráfico actual',
                    value: '82 MB/s',
                    icon: Icons.swap_vert_rounded,
                    color: AppColors.cyan,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Nodos de la plataforma',
            subtitle: 'Recursos y estado actual de cada servidor.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth >= 900
                  ? (constraints.maxWidth - 18) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: nodes
                    .map(
                      (node) => NodeCard(
                        width: cardWidth,
                        data: node,
                        onRestart: () => onMessage(
                          '${node.name} se está reiniciando.',
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
