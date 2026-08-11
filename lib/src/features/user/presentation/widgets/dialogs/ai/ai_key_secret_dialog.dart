// ==========================================
// Qué hace: Modal para mostrar la clave secreta recién creada o rotada con botón para copiar únicamente el secreto puro al portapapeles.
// Dónde se conecta: Invocado desde AiKeyActionsHelper tras crear o rotar una API Key.
// De dónde recibe datos: Recibe el valor 'secret' devuelto por el servidor C#.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core Theme

/// Diálogo modal destacado que muestra la clave secreta de API por única vez
class AiKeySecretDialog extends StatelessWidget {
  const AiKeySecretDialog({
    required this.title,   // Título a mostrar en la cabecera
    required this.secret,  // Secreto puro de la clave (ej: pr_ai_...)
    super.key,
  });

  final String title;   // Atributo con el título del modal
  final String secret;  // Atributo con la clave secreta pura

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema global
    final isDark = theme.brightness == Brightness.dark; // Verificación de modo oscuro

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return AlertDialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          const Icon(Icons.key_rounded, color: AppColors.success, size: 24),
          const SizedBox(width: 10),
          Text(title, style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
      content: SizedBox(
        width: 480,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guarda esta clave secreta ahora. Por razones de seguridad, no se volverá a mostrar en pantalla.',
              style: TextStyle(color: subtitleColor, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Contenedor del secreto de la clave
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SelectableText(
                      secret,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isDark ? const Color(0xFF38BDF8) : AppColors.navy,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 18),
                    tooltip: 'Copiar clave',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: secret)); // Copia únicamente el String de la clave
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Clave secreta copiada al portapapeles.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alerta de advertencia
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.30)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Asegúrate de copiarla en tu archivo .env o gestor de secretos antes de cerrar este cuadro.',
                      style: TextStyle(color: titleColor, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          icon: const Icon(Icons.copy_all_rounded, size: 18),
          label: const Text('Copiar y Cerrar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: secret)); // Copia EXACTAMENTE el String puro de la clave secreta
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Clave secreta copiada al portapapeles.')),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
