// ==========================================
// Qué hace: Orquesta el diálogo modal de creación de BD, diálogo de confirmación y visualización de credenciales.
// Dónde se conecta: Invocado desde DatabaseToolbar o EmptyDatabases en DatabasesPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef y callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/databases/create_database_dialog.dart';

/// Acción encargada del flujo de aprovisionamiento de bases de datos
abstract class DatabaseCreateAction {
  /// Abre modal de selección de motor, pide confirmación y muestra credenciales resultantes
  static Future<void> execute({
    required BuildContext context, // Contexto visual
    required WidgetRef ref, // Referencia Riverpod
    required void Function(String message, {bool success}) onMessage, // Notificador
  }) async {
    // 1. Despliega modal de selección de motor
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (result == null || !result.containsKey('engine')) return;

    final engineName = result['engine'] as String;

    if (!context.mounted) return;

    // 2. Diálogo de confirmación
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Confirmar Aprovisionamiento',
      message: '¿Estás seguro de que deseas crear una nueva instancia de $engineName?',
      confirmLabel: 'Sí, crear instancia',
      icon: Icons.rocket_launch_rounded,
      confirmColor: AppColors.navy,
    );

    if (!confirmed) return;

    onMessage('Procesando solicitud de aprovisionamiento...');

    // 3. Petición al backend
    final response = await ref.read(userDatabasesProvider.notifier).createDatabase(engine: engineName);

    if (response.error == null && response.data != null) {
      final data = response.data!;
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('¡Base de Datos Creada!'),
            content: SelectableText(
              'Guarda la contraseña ahora, no se volverá a mostrar completa:\n\n'
              '• Host: ${data['host']}:${data['port']}\n'
              '• Base de datos: ${data['databaseName']}\n'
              '• Usuario: ${data['databaseUser']}\n'
              '• Contraseña: ${data['password']}\n'
              '• Motor: ${data['engine']}',
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Entendido'),
              ),
            ],
          ),
        );
      }
    } else {
      onMessage('No se pudo crear la instancia: ${response.error}', success: false);
    }
  }
}
