import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    required this.subtitle,
    this.action,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? action;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (action != null && onAction != null)
          actionIcon == null
              ? TextButton(
                  onPressed: onAction,
                  child: Text(action!),
                )
              : FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 17),
                  label: Text(action!),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
      ],
    );
  }
}
