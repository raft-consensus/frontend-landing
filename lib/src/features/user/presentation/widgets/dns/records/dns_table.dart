// ==========================================
// Qué hace: Tabla que itera la lista de registros DNS o muestra DnsEmptyState.
// Dónde se conecta: Se incluye en DnsSslPage para organizar los subdominios.
// De dónde trae datos: Recibe la lista filtrada de DnsRecord.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_empty_state.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_row_item.dart';

/// Tabla contenedora de subdominios DNS
class DnsTable extends StatelessWidget {
  const DnsTable({
    required this.records, // Lista de registros filtrados
    required this.onEdit, // Callback de edición
    required this.onDelete, // Callback de eliminación
    required this.onMessage, // Callback de notificación
    super.key,
  });

  final List<DnsRecord> records;
  final ValueChanged<DnsRecord> onEdit;
  final ValueChanged<DnsRecord> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (records.isEmpty) {
      return const DnsEmptyState();
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: theme.dividerColor,
        ),
        itemBuilder: (context, index) {
          final item = records[index];
          return DnsRowItem(
            item: item,
            onEdit: onEdit,
            onDelete: onDelete,
            onMessage: onMessage,
          );
        },
      ),
    );
  }
}
