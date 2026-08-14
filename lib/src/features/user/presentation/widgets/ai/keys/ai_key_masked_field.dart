// ==========================================
// Qué hace: Muestra el prefijo público de la API Key (keyPrefix) con botón para copiarlo al portapapeles.
// Dónde se conecta: Consumido por AiKeyRowItem.
// De dónde trae datos: Recibe keyPrefix y callback onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// Campo visual para mostrar el prefijo de la clave con botón de copiado
class AiKeyMaskedField extends StatelessWidget {
  const AiKeyMaskedField({
    required this.keyPrefix,
    required this.onMessage,
    super.key,
  });

  final String keyPrefix;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        SelectableText(
          keyPrefix.isEmpty ? 'pr_ai_••••••••' : keyPrefix,
          style: TextStyle(fontFamily: 'monospace', color: textColor, fontSize: 13),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 16),
          tooltip: 'Copiar Prefijo',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: keyPrefix));
            onMessage('Prefijo copiado al portapapeles.', success: true);
          },
        ),
      ],
    );
  }
}
