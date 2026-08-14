// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/databases/cards/database_card_actions.dart
// Qué hace: Renderiza la fila de botones de acción para cada tarjeta de base de datos (Credenciales, Iniciar/Detener y Eliminar).
// De dónde recibe datos: Recibe la entidad DatabaseInstance, y callbacks para alternar estado, eliminar y notificaciones.
// Hacia dónde va / Cómo se conecta: Incrustado dentro de DatabaseManagementCard en el panel de usuario.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core: Paleta de colores
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain: Entidad de base de datos
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/databases/credentials_dialog.dart'; // Dialogs: Modal de credenciales

/// Botones gráficos de acción (Ver credenciales, Iniciar/Detener y Eliminar) para la tarjeta de base de datos.
class DatabaseCardActions extends StatelessWidget {
  const DatabaseCardActions({
    required this.instance,        // Instancia para verificar estado, motor e ID
    required this.onToggleState,   // Callback para alternar estado encendido/apagado
    required this.onDelete,        // Callback para eliminar la instancia
    required this.onMessage,       // Callback para notificaciones snackbar
    super.key,
  });

  final DatabaseInstance instance;                                  // Datos de la base de datos actual
  final VoidCallback onToggleState;                                 // Función al presionar Iniciar/Detener
  final VoidCallback onDelete;                                      // Función al presionar Eliminar
  final void Function(String, {bool success}) onMessage;            // Función para emitir alertas visuales

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Validación para comprobar si el motor es MySQL
    final isMySql = instance.engine.trim().toLowerCase() == 'mysql';

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        // 1. Botón de Ver Credenciales que abre CredentialsDialog
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

        // 2. Botón para alternar estado (Detener / Iniciar) con Tooltip y bloqueo para MySQL
        Tooltip(
          // Mensaje informativo que se muestra al pasar el cursor
          message: isMySql
              ? 'Esta opción no está disponible para el motor MySQL'
              : (instance.isRunning ? 'Pausar base de datos' : 'Iniciar base de datos'),
          child: OutlinedButton.icon(
            // Si es MySQL, se desactiva el callback para anular la interacción
            onPressed: isMySql ? null : onToggleState,
            icon: Icon(
              instance.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 15,
            ),
            label: Text(
              instance.isRunning ? 'Detener' : 'Iniciar',
              style: const TextStyle(fontSize: 12),
            ),
            style: OutlinedButton.styleFrom(
              // Colores en estado activo
              foregroundColor: instance.isRunning ? AppColors.warning : AppColors.success,
              // Color atenuado del texto/icono cuando el botón está desactivado
              disabledForegroundColor: theme.disabledColor.withValues(alpha: 0.6),
              side: BorderSide(
                // Borde atenuado si es MySQL para preservar la armonía visual sin llamar la atención
                color: isMySql
                    ? theme.dividerColor.withValues(alpha: 0.4)
                    : (instance.isRunning ? AppColors.warning : AppColors.success),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),

        // 3. Botón de Eliminar instancia
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
