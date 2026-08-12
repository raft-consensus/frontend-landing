import 'package:flutter/material.dart';

/// ¿Qué hace?: Renderiza los botones de acción para cada fila de flujo (Copiar Webhook y Alternar Estado).
/// ¿De dónde trae datos?: Ingesta la propiedad isActive y los callbacks de evento de la fila.
/// ¿Hacia dónde va / Cómo se conecta?: Se incrusta en el extremo derecho de N8nWorkflowRowItem.
class N8nWorkflowActions extends StatelessWidget {
  final bool isActive;                    // Estado actual del flujo
  final VoidCallback onToggleStatus;      // Callback al pulsar pausar / activar
  final VoidCallback onCopyWebhook;       // Callback al pulsar copiar URL de webhook

  const N8nWorkflowActions({
    required this.isActive,
    required this.onToggleStatus,
    required this.onCopyWebhook,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Botón de copiar Webhook URL
        IconButton(
          onPressed: onCopyWebhook, // Ejecuta la función de copiar
          icon: const Icon(Icons.link_rounded, size: 18),
          tooltip: 'Copiar URL del Webhook', // Texto flotante al pasar el mouse
        ),

        // 2. Botón de alternar entre activar y pausar
        IconButton(
          onPressed: onToggleStatus, // Alterna el estado booleano
          icon: Icon(
            isActive ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
            size: 18,
            color: isActive ? Colors.orange : Colors.green,
          ),
          tooltip: isActive ? 'Pausar Flujo' : 'Activar Flujo', // Tooltip dinámico
        ),
      ],
    );
  }
}
