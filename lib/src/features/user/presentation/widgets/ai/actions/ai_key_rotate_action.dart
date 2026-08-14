// ==========================================
// Qué hace: Solicita confirmación y ejecuta la rotación de credenciales para una API Key activa.
// Dónde se conecta: Invocado desde los botones de acción de cada fila en AiKeysTable / AiServicesPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef, la entidad AiKey y el callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/ai_key_secret_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';

/// Acción encargada de la confirmación y rotación de secretos de una API Key
abstract class AiKeyRotateAction {
  /// Muestra diálogo de advertencia y procesa la rotación generando un nuevo secreto
  static Future<void> execute({
    required BuildContext context, // Contexto de la interfaz
    required WidgetRef ref, // Referencia para mutar el provider
    required AiKey key, // Instancia de la clave a rotar
    required void Function(String message, {bool success}) onMessage, // Notificador visual
  }) async {
    // 1. Pide confirmación al usuario antes de invalidar la clave anterior
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Rotar API Key',
      message: '¿Estás seguro de que deseas rotar la clave "${key.name}"? La clave secreta anterior dejará de funcionar inmediatamente.',
      confirmLabel: 'Sí, rotar clave',
      icon: Icons.refresh_rounded,
    );

    if (!confirmed) return;

    // 2. Realiza la petición de rotación al servidor
    onMessage('Rotando API Key en el servidor...');
    final response = await ref.read(userAiProvider.notifier).rotateKey(key.id);

    // 3. Si es exitoso, muestra el diálogo con el nuevo secreto
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
}
