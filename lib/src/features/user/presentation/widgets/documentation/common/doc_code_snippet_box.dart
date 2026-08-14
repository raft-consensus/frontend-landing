// ==========================================
// Que hace: Bloque de consola oscura para mostrar fragmentos de codigo o configuracion con boton de copiar.
// De donde trae datos: Recibe el snippet de texto y el callback de notificacion.
// Donde se conecta: Consumido dentro de DocExpandableCard.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Consola de codigo oscura con accion de copiado al portapapeles
class DocCodeSnippetBox extends StatelessWidget {
  const DocCodeSnippetBox({
    required this.snippet, // Texto o codigo a renderizar
    required this.onMessage, // Callback de notificacion
    super.key,
  });

  final String snippet;
  final void Function(String message, {bool success}) onMessage;

  void _copy(BuildContext context) {
    Clipboard.setData(ClipboardData(text: snippet));
    onMessage('Snippet copiado al portapapeles.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF06101E) : const Color(0xFF03132F),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E3A5F) : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ejemplo / Configuración',
                style: TextStyle(
                  color: Color(0xFF88A0C0),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
              InkWell(
                onTap: () => _copy(context),
                borderRadius: BorderRadius.circular(4),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.copy_rounded, color: AppColors.cyan, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Copiar',
                        style: TextStyle(
                          color: AppColors.cyan,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SelectableText(
            snippet,
            style: const TextStyle(
              color: Color(0xFFE0EDFB),
              fontSize: 12,
              fontFamily: 'monospace',
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
