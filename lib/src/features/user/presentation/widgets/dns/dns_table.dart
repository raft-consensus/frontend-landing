import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_row_item.dart'; // Widgets

/// ¿Qué hace?: Tabla contenedora que itera la lista de registros DNS y muestra el estado vacío si no hay coincidencias.
/// ¿De dónde trae datos?: Ingesta DnsRecord, DnsRowItem y se adapta a Theme.of(context).
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en DnsSslPage para organizar visualmente los registros.
class DnsTable extends StatelessWidget {
  const DnsTable({
    required this.records,
    required this.onEdit,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final List<DnsRecord> records;
  final ValueChanged<DnsRecord> onEdit;
  final ValueChanged<DnsRecord> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (records.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
        ),
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

  /// Estado vacío cuando no existen registros coincidentes
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.dns_outlined, size: 48, color: subtitleColor),
          const SizedBox(height: 12),
          Text(
            'No se encontraron registros DNS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Crea un nuevo subdominio o modifica los términos de búsqueda',
            style: TextStyle(color: subtitleColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
