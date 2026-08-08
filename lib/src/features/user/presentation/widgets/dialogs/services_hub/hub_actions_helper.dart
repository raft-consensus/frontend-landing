import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/create_ai_key_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/databases/create_database_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/dns/create_edit_dns_dialog.dart';

/// ¿Qué hace?: Clase de utilidad que encapsula la lógica de creación directa de BDs, DNS y claves de IA desde el Hub.
/// ¿De dónde trae datos?: Interactúa directamente con userDatabasesProvider, userAiProvider y userDnsProvider mediante WidgetRef.
/// ¿Hacia dónde va / Cómo se conecta?: Invocada desde HubServicesList al presionar los botones de creación directa.
class HubActionsHelper {
  /// Ejecuta el flujo completo de creación de una nueva Base de Datos
  static Future<void> createDatabaseDirectly({
    required BuildContext context,
    required WidgetRef ref,
    void Function(String message, {bool success})? onMessage,
  }) async {
    // 1. Muestra el modal para seleccionar el motor de BD
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (result != null && result.containsKey('engine')) {
      final engineName = result['engine'] as String;

      if (!context.mounted) return;

      // 2. Pide confirmación previa
      final confirmed = await showConfirmDialog(
        context: context,
        title: 'Confirmar Aprovisionamiento',
        message: '¿Estás seguro de que deseas crear una nueva instancia de $engineName?',
        confirmLabel: 'Sí, crear instancia',
        icon: Icons.rocket_launch_rounded,
        confirmColor: AppColors.navy,
      );

      if (!confirmed) return;

      onMessage?.call('Procesando solicitud de aprovisionamiento...');

      // 3. Envía la petición real de creación al backend mediante Riverpod
      final response = await ref.read(userDatabasesProvider.notifier).createDatabase(engine: engineName);

      if (response.error == null && response.data != null) {
        final data = response.data!;
        if (context.mounted) {
          // 4. Muestra las credenciales generadas en un AlertDialog
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
        onMessage?.call('No se pudo crear la instancia: ${response.error}', success: false);
      }
    }
  }

  /// Ejecuta el flujo oficial de creación de un subdominio DNS utilizando CreateEditDnsDialog
  static Future<void> createDnsDirectly({
    required BuildContext context,
    required WidgetRef ref,
    void Function(String message, {bool success})? onMessage,
  }) async {
    // 1. Muestra el modal oficial de DNS
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateEditDnsDialog(),
    );

    if (result != null) {
      final sub = result['subdomain'] as String;
      final ip = result['targetIp'] as String;
      final comm = result['comment'] as String?;

      // 2. Invoca al provider de DNS para registrar en Cloudflare
      final error = await ref
          .read(userDnsProvider.notifier)
          .addRecord(subdomain: sub, targetIp: ip, comment: comm);

      if (error != null) {
        onMessage?.call(error, success: false);
      } else {
        onMessage?.call(
          'Subdominio $sub.coderhivex.com aprovisionado correctamente en Cloudflare.',
          success: true,
        );
      }
    }
  }

  /// Ejecuta el flujo completo de creación de una nueva clave de IA
  static Future<void> createAiKeyDirectly({
    required BuildContext context,
    required WidgetRef ref,
    void Function(String message, {bool success})? onMessage,
  }) async {
    // 1. Muestra el modal para ingresar el nombre de la clave
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAiKeyDialog(),
    );

    if (result != null && result.containsKey('name')) {
      final name = result['name'] as String;

      // 2. Guarda la clave en el estado global de Riverpod
      final error = await ref.read(userAiProvider.notifier).addKey(name: name);

      // 3. Notifica el resultado
      onMessage?.call(
        error ?? 'API Key "$name" generada correctamente.',
        success: error == null,
      );
    }
  }
}
