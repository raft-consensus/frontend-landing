import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/credentials_dialog.dart'; // Dialogs

/// ¿Qué hace?: Botones gráficos de acción (Ver credenciales, Iniciar/Detener y Eliminar) para la tarjeta de base de datos.
/// ¿De dónde recibe datos?: Recibe DatabaseInstance, onToggleState, onDelete y onMessage callbacks.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro de DatabaseManagementCard en el módulo de databases.
class DatabaseCardActions extends StatelessWidget {
  const DatabaseCardActions({
    required this.instance,        // Instancia para verificar estado e ID
    required this.onToggleState,   // Callback para alternar estado encendido/apagado
    required this.onDelete,        // Callback para eliminar la instancia
    required this.onMessage,       // Callback para notificaciones snackbar
    super.key,
  });

  final DatabaseInstance instance;
  final VoidCallback onToggleState;
  final VoidCallback onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        // Botón de Ver Credenciales que abre CredentialsDialog
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CredentialsDialog(
                instance: instance,
                onMessage: onMessage,
              ),
            );
          },
          icon: const Icon(Icons.key_rounded, size: 15),
          label: const Text('Credenciales', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
            side: BorderSide(color: theme.dividerColor),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Botón para alternar estado (Detener / Iniciar)
        OutlinedButton.icon(
          onPressed: onToggleState,
          icon: Icon(
            instance.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            size: 15,
          ),
          label: Text(
            instance.isRunning ? 'Detener' : 'Iniciar',
            style: const TextStyle(fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: instance.isRunning ? AppColors.warning : AppColors.success,
            side: BorderSide(
              color: instance.isRunning ? AppColors.warning : AppColors.success,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),

        // Botón de Eliminar instancia
        IconButton(
          onPressed: onDelete,
          icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
          tooltip: 'Eliminar instancia',
          padding: const EdgeInsets.all(6),
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
