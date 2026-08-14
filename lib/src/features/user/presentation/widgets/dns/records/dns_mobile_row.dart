// ==========================================
// Qué hace: Fila compacta vertical optimizada para pantallas móviles.
// Dónde se conecta: Consumido por DnsRowItem.
// De dónde trae datos: Recibe DnsRecord y callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_row_actions.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_status_badges.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_type_badge.dart';

/// Fila compacta de registro DNS para móviles
class DnsMobileRow extends StatelessWidget {
  const DnsMobileRow({
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Icon(Icons.link_rounded, color: theme.colorScheme.primary, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 6,
                children: [
                  SelectableText(
                    item.fqdn,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary,
                    ),
                  ),
                  DnsTypeBadge(type: item.type),
                ],
              ),
            ),
            DnsRowActions(
              item: item,
              onEdit: onEdit,
              onDelete: onDelete,
              onMessage: onMessage,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'IP Destino: ${item.content}${item.comment != null && item.comment!.isNotEmpty ? "  •  Nota: ${item.comment}" : ""}',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
          ),
        ),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [DirectTcpBadge(), SslBadge()],
        ),
      ],
    );
  }
}
