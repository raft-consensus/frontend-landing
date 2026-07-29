import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget


class EngineDistributionCard extends StatelessWidget {
  const EngineDistributionCard({
    required this.databases,
    super.key,
  });

  final List<ManagedDatabase> databases;

  int count(String engine) {
    return databases.where((database) => database.engine == engine).length;
  }

  @override
  Widget build(BuildContext context) {
    final total = math.max(databases.length, 1);

    return AdminCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribución por motor',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Instancias activas y detenidas',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 23),
          EngineProgress(
            label: 'PostgreSQL',
            count: count('PostgreSQL'),
            total: total,
            color: const Color(0xFF3977A8),
          ),
          EngineProgress(
            label: 'MySQL',
            count: count('MySQL'),
            total: total,
            color: AppColors.blue,
          ),
          EngineProgress(
            label: 'MongoDB',
            count: count('MongoDB'),
            total: total,
            color: AppColors.green,
          ),
          EngineProgress(
            label: 'SQL Server',
            count: count('SQL Server'),
            total: total,
            color: AppColors.red,
          ),
        ],
      ),
    );
  }
}

class EngineProgress extends StatelessWidget {
  const EngineProgress({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    super.key,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$count instancias',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: count / total,
              minHeight: 7,
              color: color,
              backgroundColor: color.withValues(alpha: 0.09),
            ),
          ),
        ],
      ),
    );
  }
}
