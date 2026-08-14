// ==========================================
// Qué hace: Layout horizontal de escritorio para cada API Key con tokens alineados al centro.
// Dónde se conecta: Consumido por AiKeyRowItem dentro de un LayoutBuilder.
// De dónde trae datos: Recibe la entidad AiKey, estado de hover y callbacks de acciones.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_action_buttons.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_info_column.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_masked_field.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_status_badge.dart';

/// Fila de escritorio con columnas alineadas y contador de tokens al centro
class AiKeyDesktopRow extends StatelessWidget {
  const AiKeyDesktopRow({
    required this.item, // Entidad de la API Key
    required this.isHovered, // Indica si el cursor está sobre la fila
    required this.onRotate, // Callback para rotar la clave
    required this.onDelete, // Callback para revocar la clave
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final AiKey item; // Entidad AiKey
  final bool isHovered; // Estado visual de hover
  final ValueChanged<AiKey> onRotate; // Evento de rotación
  final ValueChanged<AiKey> onDelete; // Evento de revocación
  final void Function(String message, {bool success}) onMessage; // Evento de notificaciones

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

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

        // 2. Prefijo enmascarado y botón para copiar
        Expanded(
          flex: 3,
          child: AiKeyMaskedField(
            keyPrefix: item.keyPrefix,
            onMessage: onMessage,
          ),
        ),

        // 3. Peticiones acumuladas y último uso
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${item.totalRequests} reqs',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: valueColor),
              ),
              const SizedBox(height: 4),
              Text(
                item.lastUsedAt != null ? 'Último uso: ${item.lastUsedAt}' : 'Sin uso aún',
                style: TextStyle(fontSize: 11, color: labelColor),
              ),
            ],
          ),
        ),

        // 4. Contador de Tokens alineado al CENTRO
        Expanded(
          flex: 3,
          child: Center(
            child: Text(
              '${item.totalTokens} tokens',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: labelColor),
            ),
          ),
        ),
        const SizedBox(width: 16),

        // 5. Badge de estado reactivo (Activa)
        AiKeyStatusBadge(status: item.status),
        const SizedBox(width: 12),

        // 6. Botonera de acciones (Rotar y Revocar)
        AiKeyActionButtons(
          item: item,
          onRotate: onRotate,
          onDelete: onDelete,
        ),
      ],
    );
  }
}
