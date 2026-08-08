import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/dns/create_edit_dns_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_table.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_toolbar.dart';

/// ¿Qué hace?: Vista de la pestaña Dominio & SSL para gestionar subdominios A en Cloudflare y estado de certificados.
/// ¿De dónde trae?: Escucha userDnsProvider y userDatabasesProvider usando Riverpod.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye dentro del IndexedStack principal de DashboardPage.
class DnsSslPage extends ConsumerStatefulWidget {
  const DnsSslPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage;

  @override
  ConsumerState<DnsSslPage> createState() => _DnsSslPageState();
}

class _DnsSslPageState extends ConsumerState<DnsSslPage> {
  String _searchQuery = '';

  /// Abre el modal reutilizable para crear o editar un registro DNS
  Future<void> _openCreateOrEditDialog([DnsRecord? recordToEdit]) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => CreateEditDnsDialog(initialRecord: recordToEdit),
    );

    if (result != null) {
      final sub = result['subdomain'] as String;
      final ip = result['targetIp'] as String;
      final comm = result['comment'] as String?;

      if (recordToEdit != null) {
        // Edición
        final error = await ref
            .read(userDnsProvider.notifier)
            .updateRecord(
              id: recordToEdit.id,
              subdomain: sub,
              targetIp: ip,
              comment: comm,
            );

        if (error != null) {
          widget.onMessage(error, success: false);
        } else {
          widget.onMessage(
            'Subdominio $sub.coderhivex.com actualizado correctamente.',
            success: true,
          );
        }
      } else {
        // Creación
        final error = await ref
            .read(userDnsProvider.notifier)
            .addRecord(subdomain: sub, targetIp: ip, comment: comm);

        if (error != null) {
          widget.onMessage(error, success: false);
        } else {
          widget.onMessage(
            'Subdominio $sub.coderhivex.com aprovisionado correctamente en Cloudflare.',
            success: true,
          );
        }
      }
    }
  }

  /// Pide confirmación y elimina un registro DNS
  Future<void> _confirmAndDelete(DnsRecord record) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'Eliminar Registro DNS',
      message:
          '¿Estás seguro de que deseas eliminar el subdominio ${record.fqdn}?',
      confirmLabel: 'Sí, eliminar',
      icon: Icons.delete_forever_rounded,
    );

    if (confirmed) {
      final error = await ref
          .read(userDnsProvider.notifier)
          .deleteRecord(record.id);
      if (error != null) {
        widget.onMessage(error, success: false);
      } else {
        widget.onMessage(
          'Registro DNS ${record.fqdn} revocado correctamente.',
          success: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final allRecords = ref.watch(userDnsProvider);

    // Filtra la lista según el término ingresado en el buscador
    final filteredRecords = allRecords.where((rec) {
      final query = _searchQuery.toLowerCase().trim();
      if (query.isEmpty) return true;
      return rec.fqdn.toLowerCase().contains(query) ||
          rec.content.toLowerCase().contains(query) ||
          (rec.comment?.toLowerCase().contains(query) ?? false);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de la Sección
          const SectionHeader(
            title: 'Dominio & Certificados SSL',
            subtitle:
                'Administra tus subdominios DNS en Cloudflare (coderhivex.com) y su estado SSL',
          ),
          const SizedBox(height: 20),

          // Tarjetas de Resumen KPI Superiores
          DnsSummaryCards(totalRecords: allRecords.length),
          const SizedBox(height: 24),

          // Barra de Herramientas (Buscador y Botón "+ Nuevo Subdominio")
          DnsToolbar(
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
            },
            onCreateNew: () => _openCreateOrEditDialog(),
          ),
          const SizedBox(height: 16),

          // Tabla con los Registros DNS
          DnsTable(
            records: filteredRecords,
            onEdit: (record) => _openCreateOrEditDialog(record),
            onDelete: (record) => _confirmAndDelete(record),
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // Tarjeta Informativa al Pie
          const DnsInfoCard(),
        ],
      ),
    );
  }
}
