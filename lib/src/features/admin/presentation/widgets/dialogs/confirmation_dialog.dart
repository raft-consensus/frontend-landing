import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    this.dangerous = false,
    super.key,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool dangerous;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        dangerous
            ? Icons.warning_amber_rounded
            : Icons.help_outline_rounded,
        color: dangerous ? AppColors.red : AppColors.blue,
        size: 38,
      ),
      title: Text(title),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor:
                dangerous ? AppColors.red : AppColors.navy,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
