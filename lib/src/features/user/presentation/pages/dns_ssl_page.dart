// ==========================================
// Qué hace: Vista principal limpia de Dominio & SSL que solo ensambla los módulos segmentados.
// Dónde se conecta: Se renderiza en el índice 3 del IndexedStack en DashboardPage.
// De dónde trae datos: Escucha userDnsProvider vía Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_dns_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/actions/dns_create_or_edit_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/actions/dns_delete_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/info/dns_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/records/dns_table.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/summary/dns_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/toolbar/dns_toolbar.dart';

/// Vista modular de administración de Dominio & SSL (DNS)
class DnsSslPage extends ConsumerStatefulWidget {
  const DnsSslPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage; // Callback para emitir notificaciones

  @override
  ConsumerState<DnsSslPage> createState() => _DnsSslPageState();
}

class _DnsSslPageState extends ConsumerState<DnsSslPage> {
  String _searchQuery = ''; // Cadena de búsqueda en tiempo real

  @override
  Widget build(BuildContext context) {
    final allRecords = ref.watch(userDnsProvider); // Registros DNS desde Riverpod

    // Filtrado de registros en memoria por FQDN, IP o nota
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
          // 1. Encabezado de Sección
          const SectionHeader(
            title: 'Dominio & Certificados SSL',
            subtitle: 'Administra tus subdominios DNS en Cloudflare (coderhivex.com) y su estado SSL',
          ),
          const SizedBox(height: 20),

          // 2. Tarjetas KPI de Resumen Superior
          DnsSummaryCards(totalRecords: allRecords.length),
          const SizedBox(height: 24),

          // 3. Barra de Herramientas (Buscador expandido y Botón "+ Nuevo Subdominio")
          DnsToolbar(
            onSearchChanged: (query) => setState(() => _searchQuery = query),
            onCreateNew: () => DnsCreateOrEditAction.execute(
              context: context,
              ref: ref,
              onMessage: widget.onMessage,
            ),
          ),
          const SizedBox(height: 16),

          // 4. Tabla de Registros DNS
          DnsTable(
            records: filteredRecords,
            onEdit: (record) => DnsCreateOrEditAction.execute(
              context: context,
              ref: ref,
              recordToEdit: record,
              onMessage: widget.onMessage,
            ),
            onDelete: (record) => DnsDeleteAction.execute(
              context: context,
              ref: ref,
              record: record,
              onMessage: widget.onMessage,
            ),
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // 5. Tarjeta Informativa al Pie
          const DnsInfoCard(),
        ],
      ),
    );
  }
}
