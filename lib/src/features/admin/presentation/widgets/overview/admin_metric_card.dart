import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/colored_icon.dart'; // Widget


class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    required this.width,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.detail,
    required this.trend,
    super.key,
  });

  final double width;
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String detail;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ColoredIcon(icon: icon, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            detail,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
