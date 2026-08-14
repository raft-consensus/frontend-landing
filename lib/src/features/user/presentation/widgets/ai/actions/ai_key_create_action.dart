// ==========================================
// Qué hace: Orquesta el diálogo de creación de una nueva API Key y la visualización de su clave secreta.
// Dónde se conecta: Invocado desde la barra de herramientas (AiToolbar) en AiServicesPage.
// De dónde recibe datos: Recibe BuildContext, WidgetRef y el callback de notificaciones onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_ai_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/ai_key_secret_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/ai/create_ai_key_dialog.dart';

/// Acción encargada de la apertura del diálogo y creación de nuevas API Keys
abstract class AiKeyCreateAction {
  /// Abre el formulario modal de creación y, tras recibir respuesta exitosa, despliega el secreto generado
  static Future<void> execute({
    required BuildContext context, // Contexto para el árbol de widgets y diálogos
    required WidgetRef ref, // Referencia Riverpod para despachar mutaciones
    required void Function(String message, {bool success}) onMessage, // Callback para toasts y notificaciones
  }) async {
    // 1. Despliega el diálogo modal de entrada de datos
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateAiKeyDialog(),
    );

    // 2. Si el usuario confirmó con un nombre válido, solicita la creación al backend
    if (result != null && result.containsKey('name')) {
      final name = result['name'] as String;
      onMessage('Generando API Key en el servidor...');

      final response = await ref.read(userAiProvider.notifier).createKey(name: name);

      // 3. Evalúa si se recibió el secreto sin errores
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
}
