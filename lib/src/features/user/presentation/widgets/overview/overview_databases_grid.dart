// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/overview/overview_databases_grid.dart
// ¿Qué hace?: Renderiza la cuadrícula responsiva con las primeras 4 instancias de BD o la tarjeta vacía si no hay ninguna.
// ¿De dónde trae datos?: Recibe la lista de DatabaseInstance y callbacks de acción.
// ¿Hacia dónde va / Cómo se conecta?: Se incluye al final de OverviewPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/compact_database.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/overview_empty_databases.dart';

class OverviewDatabasesGrid extends StatelessWidget {
  const OverviewDatabasesGrid({
    required this.instances,
    required this.onGoDatabases,
    required this.onCreateDatabase,
    super.key,
  });

  final List<DatabaseInstance> instances; // Lista de instancias de BD del usuario
  final VoidCallback onGoDatabases;        // Callback para ir a la pestaña de bases de datos
  final VoidCallback onCreateDatabase;    // Callback para abrir modal de creación

  @override
  Widget build(BuildContext context) {
    final displayedInstances = instances.take(4).toList(); // Toma máximo 4 instancias

    // 1. Si no hay bases de datos, delega la vista al widget independiente de estado vacío
    if (displayedInstances.isEmpty) {
      return OverviewEmptyDatabases(
        onCreateDatabase: onCreateDatabase,
      );
    }

    // 2. Si existen bases de datos, renderiza la cuadrícula adaptativa
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cols = width >= 1100 ? 4 : (width >= 700 ? 2 : 1);
        final itemWidth = (width - (cols - 1) * 14) / cols;

        return Wrap(
          spacing: 14,
          runSpacing: 14,
          children: displayedInstances
              .map(
                (instance) => SizedBox(
                  width: itemWidth,
                  child: CompactDatabaseCard(
                    instance: instance,
                    onTap: onGoDatabases,
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}
