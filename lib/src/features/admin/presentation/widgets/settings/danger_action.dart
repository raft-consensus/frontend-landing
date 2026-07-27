import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class DangerAction extends StatelessWidget {
  const DangerAction({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;

        final information = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 10,
              ),
            ),
          ],
        );

        final button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.red,
            side: const BorderSide(color: AppColors.red),
          ),
          child: Text(buttonText),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              information,
              const SizedBox(height: 13),
              button,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: information),
            button,
          ],
        );
      },
    );
  }
}
