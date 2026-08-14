// ==========================================
// Qué hace: Solicita confirmación y ejecuta la revocación permanente de una API Key.
// Dónde se conecta: Invocado desde los botones de acción de cada fila en AiKeysTable / AiServicesPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef, la entidad AiKey y el callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';

/// Acción encargada de la confirmación y revocación permanente de una API Key
abstract class AiKeyRevokeAction {
  /// Muestra diálogo de advertencia de revocación y ejecuta el borrado lógico en el servidor
  static Future<void> execute({
    required BuildContext context, // Contexto de la interfaz
    required WidgetRef ref, // Referencia para mutar el provider
    required AiKey key, // Instancia de la clave a revocar
    required void Function(String message, {bool success}) onMessage, // Notificador visual
  }) async {
    // 1. Pide confirmación al usuario antes de inhabilitar permanentemente la clave
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Revocar API Key',
      message: '¿Estás seguro de que deseas revocar la clave "${key.name}"? La clave cambiará su estado a "Revocada" y dejará de funcionar en cualquier aplicación externa inmediatamente.',
      confirmLabel: 'Sí, revocar clave',
      icon: Icons.block_rounded,
    );

    if (!confirmed) return;

    // 2. Realiza la petición de revocación al servidor
    onMessage('Revocando API Key en el servidor...');
    final error = await ref.read(userAiProvider.notifier).deleteKey(key.id);

    // 3. Notifica el resultado final
    onMessage(
      error ?? 'API Key "${key.name}" revocada correctamente.',
      success: error == null,
    );
  }
}
