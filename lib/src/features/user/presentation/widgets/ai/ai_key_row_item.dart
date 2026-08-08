import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_delete_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_info_column.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_masked_field.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_meter_bar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_status_badge.dart';

/// ¿Qué hace?: Fila individual de API Key responsiva (se adapta automáticamente en móviles, tablets y escritorio).
/// ¿De dónde trae datos?: Ingesta la entidad AiKey y delega renderizado a subwidgets desacoplados.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en AiKeysTable.
class AiKeyRowItem extends StatefulWidget {
  const AiKeyRowItem({
    required this.item,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final AiKey item;
  final ValueChanged<AiKey> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  State<AiKeyRowItem> createState() => _AiKeyRowItemState();
}

class _AiKeyRowItemState extends State<AiKeyRowItem> {
  bool _isHovered = false; // Estado local para el resaltado de fondo al pasar el mouse

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hoverBg = theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04);
    final normalBg = Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : normalBg,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Breakpoint corregido a 600px para evitar oscilaciones con el sidebar
            final isCompact = constraints.maxWidth < 600;
            if (isCompact) {
              return _buildCompactLayout();
            }
            return _buildDesktopLayout();
          },
        ),
      ),
    );
  }

  /// Layout horizontal para escritorio y tablets (Ancho >= 600px)
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // 1. Icono, Nombre y Fecha
        Expanded(
          flex: 3,
          child: AiKeyInfoColumn(
            name: widget.item.name,
            createdAt: widget.item.createdAt,
            isHovered: _isHovered,
          ),
        ),

        // 2. Token enmascarado y Botón Copiar
        Expanded(
          flex: 3,
          child: AiKeyMaskedField(
            maskedKey: widget.item.maskedKey,
            fullApiKey: widget.item.apiKey,
            onMessage: widget.onMessage,
          ),
        ),

        // 3. Barra de Consumo
        Expanded(
          flex: 4,
          child: AiKeyMeterBar(item: widget.item),
        ),
        const SizedBox(width: 16),

        // 4. Badge de Estado
        const AiKeyStatusBadge(),
        const SizedBox(width: 16),

        // 5. Botón Cuadrado de Revocación
        AiKeyDeleteButton(onPressed: () => widget.onDelete(widget.item)),
      ],
    );
  }

  /// Layout vertical responsivo para pantallas pequeñas (Móviles / Ancho < 600px)
  Widget _buildCompactLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AiKeyInfoColumn(
                name: widget.item.name,
                createdAt: widget.item.createdAt,
                isHovered: _isHovered,
              ),
            ),
            const AiKeyStatusBadge(),
            const SizedBox(width: 10),
            AiKeyDeleteButton(onPressed: () => widget.onDelete(widget.item)),
          ],
        ),
        const SizedBox(height: 10),
        AiKeyMaskedField(
          maskedKey: widget.item.maskedKey,
          fullApiKey: widget.item.apiKey,
          onMessage: widget.onMessage,
        ),
        const SizedBox(height: 10),
        AiKeyMeterBar(item: widget.item),
      ],
    );
  }
}
