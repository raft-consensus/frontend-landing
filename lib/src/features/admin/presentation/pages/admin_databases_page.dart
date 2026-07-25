import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/filter_bar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/empty_state.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/databases/managed_database_card.dart'; // Widget


class AdminDatabasesPage extends StatefulWidget {
  const AdminDatabasesPage({
    required this.databases,
    required this.onToggle,
    required this.onDelete,
    required this.onDetails,
    required this.onMessage,
    super.key,
  });

  final List<ManagedDatabase> databases;
  final ValueChanged<ManagedDatabase> onToggle;
  final ValueChanged<ManagedDatabase> onDelete;
  final ValueChanged<ManagedDatabase> onDetails;
  final void Function(String, {bool success}) onMessage;

  @override
  State<AdminDatabasesPage> createState() => _AdminDatabasesPageState();
}

class _AdminDatabasesPageState extends State<AdminDatabasesPage> {
  String _query = '';
  String _engine = 'Todos';

  List<ManagedDatabase> get filtered {
    return widget.databases.where((database) {
      final query = _query.toLowerCase();

      return (database.name.toLowerCase().contains(query) ||
              database.owner.toLowerCase().contains(query)) &&
          (_engine == 'Todos' || database.engine == _engine);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Bases de datos de la plataforma',
            subtitle:
                'Supervisa todas las instancias creadas por los usuarios.',
            action: 'Exportar listado',
            actionIcon: Icons.download_rounded,
            onAction: () => widget.onMessage(
              'El listado se está exportando.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar instancia o propietario...',
            selectedFilter: _engine,
            filters: const [
              'Todos',
              'MySQL',
              'PostgreSQL',
              'SQL Server',
              'MongoDB',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _engine = value),
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.storage_rounded,
              title: 'No encontramos instancias',
              description: 'Prueba con otro filtro o término de búsqueda.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 950
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filtered
                      .map(
                        (database) => ManagedDatabaseCard(
                          width: cardWidth,
                          database: database,
                          onDetails: () =>
                              widget.onDetails(database),
                          onToggle: () => widget.onToggle(database),
                          onDelete: () => widget.onDelete(database),
                          onRestart: () => widget.onMessage(
                            '${database.name} se está reiniciando.',
                            success: true,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
