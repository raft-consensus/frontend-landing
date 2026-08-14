// ==========================================
// Qué hace: Contenedor con animación hover que selecciona entre DnsDesktopRow y DnsMobileRow.
// Dónde se conecta: Consumido dentro del ListView en DnsTable.
// De dónde trae datos: Recibe el registro DnsRecord y callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_desktop_row.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_mobile_row.dart';

/// Fila individual de subdominio con animación Hover reactiva
class DnsRowItem extends StatefulWidget {
  const DnsRowItem({
    required this.item, // Registro DNS
    required this.onEdit, // Callback de edición
    required this.onDelete, // Callback de eliminación
    required this.onMessage, // Callback de notificación
    super.key,
  });

  final DnsRecord item;
  final ValueChanged<DnsRecord> onEdit;
  final ValueChanged<DnsRecord> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  State<DnsRowItem> createState() => _DnsRowItemState();
}

class _DnsRowItemState extends State<DnsRowItem> {
  bool _isHovered = false; // Estado reactivo de hover

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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 650;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: isSmall
                  ? DnsMobileRow(
                      item: widget.item,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                      onMessage: widget.onMessage,
                    )
                  : DnsDesktopRow(
                      item: widget.item,
                      isHovered: _isHovered,
                      onEdit: widget.onEdit,
                      onDelete: widget.onDelete,
                      onMessage: widget.onMessage,
                    ),
            );
          },
        ),
      ),
    );
  }
}
