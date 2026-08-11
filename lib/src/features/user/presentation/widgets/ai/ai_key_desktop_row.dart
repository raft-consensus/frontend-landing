// ==========================================
// Qué hace: Layout horizontal exclusivo para pantallas de escritorio (Ancho >= 650px).
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

/// Componente atómico que representa el layout de escritorio de la fila de API Key
class AiKeyDesktopRow extends StatelessWidget {
  const AiKeyDesktopRow({
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
    return Row(
      children: [
        // 1. Icono, Nombre de la clave y Fecha de creación
        Expanded(
          flex: 3,
          child: AiKeyInfoColumn(
            name: item.name,
            createdAt: item.createdAt,
            isHovered: isHovered,
          ),
        ),

        // 2. Prefijo enmascarado de la clave y Botón para copiar
        Expanded(
          flex: 3,
          child: AiKeyMaskedField(
            keyPrefix: item.keyPrefix,
            onMessage: onMessage,
          ),
        ),

        // 3. Barra de nivel de uso (Peticiones acumuladas y Tokens)
        Expanded(
          flex: 4,
          child: AiKeyMeterBar(item: item),
        ),
        const SizedBox(width: 16),

        // 4. Badge de estado reactivo (Activa / Revocada)
        AiKeyStatusBadge(status: item.status),
        const SizedBox(width: 12),

        // 5. Botonera de acciones (Rotar y Revocar)
        AiKeyActionButtons(
          item: item,
          onRotate: onRotate,
          onDelete: onDelete,
        ),
      ],
    );
  }
}
