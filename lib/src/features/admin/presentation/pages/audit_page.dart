import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/filter_bar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_card.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/empty_state.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/audit/audit_event_row.dart'; // Widget

class AuditPage extends StatefulWidget {
  const AuditPage({
    required this.events,
    super.key,
  });

  final List<AuditEvent> events;

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  String _query = '';
  String _level = 'Todos';

  List<AuditEvent> get filtered {
    return widget.events.where((event) {
      final query = _query.toLowerCase();

      final matchesQuery =
          event.action.toLowerCase().contains(query) ||
              event.actor.toLowerCase().contains(query) ||
              event.resource.toLowerCase().contains(query);

      final matchesLevel = _level == 'Todos' ||
          (_level == 'Información' &&
              event.level == AuditLevel.info) ||
          (_level == 'Advertencias' &&
              event.level == AuditLevel.warning) ||
          (_level == 'Críticos' &&
              event.level == AuditLevel.critical);

      return matchesQuery && matchesLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Registro de auditoría',
            subtitle:
                'Consulta acciones administrativas y eventos de seguridad.',
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar acción, usuario o recurso...',
            selectedFilter: _level,
            filters: const [
              'Todos',
              'Información',
              'Advertencias',
              'Críticos',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _level = value),
          ),
          const SizedBox(height: 18),
          AdminCard(
            padding: const EdgeInsets.all(0),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(35),
                    child: EmptyStateContent(
                      icon: Icons.policy_rounded,
                      title: 'No encontramos eventos',
                      description: 'Modifica los filtros de búsqueda.',
                    ),
                  )
                : Column(
                    children: filtered
                        .map((event) => AuditEventRow(event: event))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
