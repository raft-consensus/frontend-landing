// ==========================================
// Qué hace: Widget contenedor y coordinador responsivo de una fila de API Key en la tabla.
// Dónde se conecta: Se incluye dentro de AiKeysTable.
// De dónde trae datos: Recibe la entidad AiKey y delega el renderizado a AiKeyDesktopRow o AiKeyCompactRow.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_compact_row.dart'; // Compact Row
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/keys/ai_key_desktop_row.dart'; // Desktop Row

/// Coordinador responsivo de la fila de una API Key
class AiKeyRowItem extends StatefulWidget {
  const AiKeyRowItem({
    required this.item,       // Entidad de la API Key
    required this.onRotate,   // Callback para rotación
    required this.onDelete,   // Callback para revocación
    required this.onMessage,  // Callback para mensajes
    super.key,
  });

  final AiKey item;                                                    // Entidad AiKey
  final ValueChanged<AiKey> onRotate;                                  // Evento al presionar rotar
  final ValueChanged<AiKey> onDelete;                                  // Evento al presionar revocar
  final void Function(String message, {bool success}) onMessage;       // Evento de notificación

  @override
  State<AiKeyRowItem> createState() => _AiKeyRowItemState();
}

class _AiKeyRowItemState extends State<AiKeyRowItem> {
  bool _isHovered = false; // Estado reactivo de hover

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema global
    final isDark = theme.brightness == Brightness.dark; // Verificación de modo oscuro

    final hoverBg = theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04); // Fondo al hacer hover

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),   // Activa hover
      onExit: (_) => setState(() => _isHovered = false),   // Desactiva hover
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : Colors.transparent, // Fondo reactivo
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 650; // Determina si la pantalla es estrecha
            if (isCompact) {
              return AiKeyCompactRow(
                item: widget.item,
                isHovered: _isHovered,
                onRotate: widget.onRotate,
                onDelete: widget.onDelete,
                onMessage: widget.onMessage,
              );
            }
            return AiKeyDesktopRow(
              item: widget.item,
              isHovered: _isHovered,
              onRotate: widget.onRotate,
              onDelete: widget.onDelete,
              onMessage: widget.onMessage,
            );
          },
        ),
      ),
    );
  }
}
