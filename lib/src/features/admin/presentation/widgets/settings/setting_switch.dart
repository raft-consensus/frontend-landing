import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.dangerous = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final bool dangerous;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      activeColor: dangerous ? AppColors.red : AppColors.blue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          color: dangerous ? AppColors.red : AppColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 10,
        ),
      ),
    );
  }
}
