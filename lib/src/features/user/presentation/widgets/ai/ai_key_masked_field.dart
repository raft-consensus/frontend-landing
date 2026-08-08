import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Muestra el token de la clave enmascarada con botón para copiar al portapapeles.
/// ¿De dónde trae datos?: Ingesta maskedKey, apiKey completa y callback onMessage.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido por AiKeyRowItem.
class AiKeyMaskedField extends StatelessWidget {
  const AiKeyMaskedField({
    required this.maskedKey,
    required this.fullApiKey,
    required this.onMessage,
    super.key,
  });

  final String maskedKey;
  final String fullApiKey;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      children: [
        SelectableText(
          maskedKey,
          style: TextStyle(fontFamily: 'monospace', color: textColor, fontSize: 13),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 16),
          tooltip: 'Copiar API Key',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: fullApiKey));
            onMessage('API Key copiada al portapapeles.', success: true);
          },
        ),
      ],
    );
  }
}
