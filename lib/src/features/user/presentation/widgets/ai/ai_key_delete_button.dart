import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Botón cuadrado estilizado de 36x36 px para revocar la API Key.
/// ¿De dónde trae datos?: Recibe el callback de eliminación.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido por AiKeyRowItem.
class AiKeyDeleteButton extends StatelessWidget {
  const AiKeyDeleteButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Revocar API Key',
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        hoverColor: AppColors.error.withValues(alpha: 0.25),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
          ),
          child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
        ),
      ),
    );
  }
}
