import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_row_item.dart';

/// ¿Qué hace?: Tabla contenedora que itera la lista de registros DNS y muestra el estado vacío si no hay coincidencias.
/// ¿De dónde trae?: Consume AppColors de core/theme, DnsRecord y DnsRowItem.
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (records.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.border,
        ),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: isDark ? const Color(0xFF334155) : AppColors.border,
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.border,
        ),
      ),
      child: const Column(
        children: [
          Icon(Icons.dns_outlined, size: 48, color: AppColors.muted),
          SizedBox(height: 12),
          Text(
            'No se encontraron registros DNS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Crea un nuevo subdominio o modifica los términos de búsqueda',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
