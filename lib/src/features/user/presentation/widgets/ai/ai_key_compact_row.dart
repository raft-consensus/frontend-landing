// ==========================================
// Qué hace: Layout vertical responsivo exclusivo para pantallas pequeñas/móviles (Ancho < 650px).
// Dónde se conecta: Consumido por AiKeyRowItem dentro de un LayoutBuilder.
// De dónde trae datos: Recibe la entidad AiKey, el estado de hover y los callbacks de acciones y mensajes.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain Entity
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_action_buttons.dart'; // Action Buttons
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_info_column.dart'; // Info Column
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_masked_field.dart'; // Masked Field
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_meter_bar.dart'; // Meter Bar
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_status_badge.dart'; // Status Badge

/// Componente atómico que representa el layout móvil/compacto de la fila de API Key
class AiKeyCompactRow extends StatelessWidget {
  const AiKeyCompactRow({
    required this.item,       // Entidad de la API Key
    required this.isHovered,  // Indica si el cursor está sobre la fila
    required this.onRotate,   // Callback para rotar la clave
    required this.onDelete,   // Callback para revocar la clave
    required this.onMessage,  // Callback para notificaciones
    super.key,
  });

  final AiKey item;                                                    // Entidad AiKey
  final bool isHovered;                                                // Estado visual de hover
  final ValueChanged<AiKey> onRotate;                                  // Evento de rotación
  final ValueChanged<AiKey> onDelete;                                  // Evento de revocación
  final void Function(String message, {bool success}) onMessage;       // Evento de notificaciones

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila superior: Información principal, Badge de estado y Acciones
        Row(
          children: [
            Expanded(
              child: AiKeyInfoColumn(
                name: item.name,
                createdAt: item.createdAt,
                isHovered: isHovered,
              ),
            ),
            AiKeyStatusBadge(status: item.status),
            const SizedBox(width: 4),
            AiKeyActionButtons(
              item: item,
              onRotate: onRotate,
              onDelete: onDelete,
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Campo enmascarado del prefijo de la clave
        AiKeyMaskedField(
          keyPrefix: item.keyPrefix,
          onMessage: onMessage,
        ),
        const SizedBox(height: 10),

        // Barra con resumen de peticiones y métricas de consumo
        AiKeyMeterBar(item: item),
      ],
    );
  }
}
