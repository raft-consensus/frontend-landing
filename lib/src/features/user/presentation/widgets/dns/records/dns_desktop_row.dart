// ==========================================
// Qué hace: Fila horizontal optimizada para escritorio con icono, FQDN, IP, badges y acciones.
// Dónde se conecta: Consumido por DnsRowItem.
// De dónde trae datos: Recibe DnsRecord, bandera isHovered y callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_row_actions.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_status_badges.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_type_badge.dart';

/// Fila tabular de registro DNS para pantallas de escritorio
class DnsDesktopRow extends StatelessWidget {
  const DnsDesktopRow({
    required this.item, // Registro DNS
    required this.isHovered, // Estado de hover
    required this.onEdit, // Callback de edición
    required this.onDelete, // Callback de eliminación
    required this.onMessage, // Callback de notificación
    super.key,
  });

  final DnsRecord item;
  final bool isHovered;
  final ValueChanged<DnsRecord> onEdit;
  final ValueChanged<DnsRecord> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Icono circular con resplandor
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: isHovered ? 0.20 : 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.link_rounded, color: theme.colorScheme.primary, size: 18),
        ),
        const SizedBox(width: 14),

        // Información de FQDN e IP destino
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SelectableText(
                    item.fqdn,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DnsTypeBadge(type: item.type),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'IP Destino: ${item.content}${item.comment != null && item.comment!.isNotEmpty ? "  •  Nota: ${item.comment}" : ""}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const DirectTcpBadge(),
        const SizedBox(width: 8),
        const SslBadge(),
        const SizedBox(width: 12),
        DnsRowActions(
          item: item,
          onEdit: onEdit,
          onDelete: onDelete,
          onMessage: onMessage,
        ),
      ],
    );
  }
}
