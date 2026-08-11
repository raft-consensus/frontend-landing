// ==========================================
// Qué hace: Helper encargado de orquestar los diálogos de creación, rotación y revocación de API Keys de IA.
// Dónde se conecta: Consumido por AiServicesPage y desacopla la lógica de presentación del flujo de diálogos.
// De dónde recibe datos: Recibe BuildContext, WidgetRef, la entidad AiKey y el callback de notificaciones.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart'; // Riverpod Provider
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/ai_key_secret_dialog.dart'; // Diálogo Secreto
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/create_ai_key_dialog.dart'; // Diálogo Crear
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart'; // Diálogo Confirmar

/// Helper estático para la gestión de acciones y diálogos de API Keys
abstract class AiKeyActionsHelper {
  /// Abre el diálogo para crear una nueva API Key y presenta la clave secreta al usuario
  static Future<void> openCreateDialog({
    required BuildContext context,                                      // Contexto para mostrar diálogos
    required WidgetRef ref,                                             // Referencia de Riverpod para consultar providers
    required void Function(String message, {bool success}) onMessage,  // Callback para notificaciones en pantalla
  }) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAiKeyDialog(),
    );

    if (result != null && result.containsKey('name')) {
      final name = result['name'] as String;
      onMessage('Generando API Key en el servidor...');

      final response = await ref.read(userAiProvider.notifier).createKey(name: name);

      if (response.error == null && response.secret != null && response.secret!.isNotEmpty) {
        onMessage('API Key "$name" generada con éxito.', success: true);
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (context) => AiKeySecretDialog(
              title: 'API Key Generada',
              secret: response.secret!,
            ),
          );
        }
      } else {
        onMessage(
          response.error ?? 'No se pudo generar la API Key.',
          success: false,
        );
      }
    }
  }

  /// Pide confirmación y rota una API Key activa
  static Future<void> confirmAndRotate({
    required BuildContext context,                                      // Contexto para mostrar diálogos
    required WidgetRef ref,                                             // Referencia a Riverpod
    required AiKey key,                                                 // Entidad de la API Key a rotar
    required void Function(String message, {bool success}) onMessage,  // Callback de mensajes
  }) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Rotar API Key',
      message: '¿Estás seguro de que deseas rotar la clave "${key.name}"? La clave secreta anterior dejará de funcionar inmediatamente.',
      confirmLabel: 'Sí, rotar clave',
      icon: Icons.refresh_rounded,
    );

    if (!confirmed) return;

    onMessage('Rotando API Key en el servidor...');
    final response = await ref.read(userAiProvider.notifier).rotateKey(key.id);

    if (response.error == null && response.secret != null && response.secret!.isNotEmpty) {
      onMessage('API Key "${key.name}" rotada con éxito.', success: true);
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AiKeySecretDialog(
            title: 'Nueva Clave Secreta Rotada',
            secret: response.secret!,
          ),
        );
      }
    } else {
      onMessage(
        response.error ?? 'No se pudo rotar la API Key.',
        success: false,
      );
    }
  }

  /// Pide confirmación y revoca la API Key inhabilitándola en el servidor
  static Future<void> confirmAndRevoke({
    required BuildContext context,                                      // Contexto para mostrar diálogos
    required WidgetRef ref,                                             // Referencia a Riverpod
    required AiKey key,                                                 // Entidad de la API Key a revocar
    required void Function(String message, {bool success}) onMessage,  // Callback de mensajes
  }) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Revocar API Key',
      message: '¿Estás seguro de que deseas revocar la clave "${key.name}"? La clave cambiará su estado a "Revocada" y dejará de funcionar en cualquier aplicación externa inmediatamente.',
      confirmLabel: 'Sí, revocar clave',
      icon: Icons.block_rounded,
    );

    if (!confirmed) return;

    onMessage('Revocando API Key en el servidor...');
    final error = await ref.read(userAiProvider.notifier).deleteKey(key.id);

    onMessage(
      error ?? 'API Key "${key.name}" revocada correctamente.',
      success: error == null,
    );
  }
}
