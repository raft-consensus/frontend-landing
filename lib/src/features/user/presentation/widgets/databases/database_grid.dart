import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_management_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/empty_databases.dart';

/// ¿Qué hace?: Grilla responsiva de tarjetas de bases de datos que aplica filtros y maneja el estado vacío.
/// ¿De dónde trae datos?: Ingesta la lista de instancias y notifica eventos de cambio de estado o eliminación a Riverpod.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en DatabasesPage.
class DatabaseGrid extends ConsumerWidget {
  const DatabaseGrid({
    required this.instances,
    required this.selectedEngine,
    required this.searchQuery,
    required this.onCreate,
    required this.onMessage,
    super.key,
  });

  final List<DatabaseInstance> instances;
  final String selectedEngine;
  final String searchQuery;
  final VoidCallback onCreate;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filtra las instancias en tiempo real
    final filtered = instances.where((instance) {
      final matchesFilter = selectedEngine == 'Todos' || instance.engine == selectedEngine;
      final matchesSearch = instance.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          instance.host.toLowerCase().contains(searchQuery.toLowerCase()) ||
          instance.database.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    if (filtered.isEmpty) {
      return EmptyDatabases(onCreateDatabase: onCreate);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount = width >= 1200 ? 3 : (width >= 768 ? 2 : 1);
        const double spacing = 16.0;
        final double itemWidth = crossAxisCount == 1
            ? width
            : (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: filtered.map((instance) {
            return SizedBox(
              width: itemWidth,
              child: DatabaseManagementCard(
                instance: instance,
                onToggleState: () {
                  ref.read(userDatabasesProvider.notifier).toggleInstanceState(instance.id);
                  onMessage('Estado de la instancia actualizado.');
                },
                onDelete: () {
                  ref.read(userDatabasesProvider.notifier).deleteDatabase(instance.id);
                  onMessage('Instancia eliminada.', success: false);
                },
                onMessage: onMessage,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
