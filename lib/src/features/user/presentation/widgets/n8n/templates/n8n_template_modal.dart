import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Diálogo modal desacoplado para visualizar e importar plantillas JSON de n8n.
/// ¿De dónde trae datos?: Ingesta el nombre de la plantilla seleccionada y genera su JSON correspondiente.
/// ¿Hacia dónde va / Cómo se conecta?: Se despliega desde N8nTemplatesSection sin recargar N8nServicesPage.
class N8nTemplateModal extends StatelessWidget {
  final String templateTitle;                                      // Título de la plantilla seleccionada
  final String templateDesc;                                       // Descripción de la plantilla
  final void Function(String message, {bool success}) onMessage;   // Callback para notificaciones SnackBar

  const N8nTemplateModal({
    required this.templateTitle,
    required this.templateDesc,
    required this.onMessage,
    super.key,
  });

  /// Genera la estructura JSON de la plantilla de n8n según el título seleccionado
  String _getTemplateJson() {
    if (templateTitle.contains('Backup')) {
      return '''{
  "name": "Alerta de Backup Raft DB",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "raft-backup-webhook",
        "options": {}
      },
      "name": "Webhook Raft DB",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300]
    }
  ],
  "connections": {}
}''';
    } else if (templateTitle.contains('Memoria') || templateTitle.contains('CPU')) {
      return '''{
  "name": "Alerta de Consumo de Recursos",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "raft-metrics-alert",
        "options": {}
      },
      "name": "Webhook de Métricas",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300]
    }
  ],
  "connections": {}
}''';
    } else {
      return '''{
  "name": "Sincronización a Google Sheets",
  "nodes": [
    {
      "parameters": {
        "httpMethod": "POST",
        "path": "sheets-sync",
        "options": {}
      },
      "name": "Webhook Tabla Raft DB",
      "type": "n8n-nodes-base.webhook",
      "typeVersion": 1,
      "position": [250, 300]
    }
  ],
  "connections": {}
}''';
    }
  }

  void _copyToClipboard(BuildContext context, String jsonContent) {
    Clipboard.setData(ClipboardData(text: jsonContent));
    onMessage(
      '¡Plantilla "$templateTitle" copiada! Abre n8n Studio y presiona Ctrl + V en el lienzo para importarla.',
      success: true,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final jsonContent = _getTemplateJson();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: theme.cardColor,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 550),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Encabezado del Modal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    templateTitle,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              templateDesc,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Visor de Código JSON de la Plantilla
            Container(
              padding: const EdgeInsets.all(14),
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  jsonContent,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: AppColors.purple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Acciones del Modal
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(context, jsonContent),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: const Text('Copiar JSON e Importar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
