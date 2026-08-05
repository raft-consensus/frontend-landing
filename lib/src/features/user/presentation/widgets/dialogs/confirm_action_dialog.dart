import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Modal reutilizable para la confirmación de acciones sensibles (Crear, Pausar, Eliminar BD).
/// ¿De dónde trae?: Recibe título, mensaje, etiquetas de botones, icono y color de confirmación.
/// ¿Dónde se conecta?: Invocado mediante `showConfirmDialog()` en `DashboardPage` y vistas de gestión.
class ConfirmActionDialog extends StatelessWidget {
  const ConfirmActionDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    this.cancelLabel = 'Cancelar',
    this.icon = Icons.help_outline_rounded,
    this.confirmColor = AppColors.navy,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final IconData icon;
  final Color confirmColor;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono destacado
              CircleAvatar(
                radius: 28,
                backgroundColor: confirmColor.withValues(alpha: 0.1),
                child: Icon(icon, color: confirmColor, size: 28),
              ),
              const SizedBox(height: 16),

              // Título
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),

              // Mensaje descriptivo
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Botones de Acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(cancelLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: FilledButton.styleFrom(
                        backgroundColor: confirmColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(confirmLabel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Función utilitaria para invocar el diálogo de confirmación y retornar un booleano (true/false)
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  IconData icon = Icons.help_outline_rounded,
  Color confirmColor = AppColors.navy,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => ConfirmActionDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      icon: icon,
      confirmColor: confirmColor,
    ),
  );
  return result ?? false;
}
