import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; 

class InformationRow extends StatelessWidget {
  const InformationRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 17),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
