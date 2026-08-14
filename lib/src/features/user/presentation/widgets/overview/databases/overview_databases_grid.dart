// ==========================================
// Qué hace: Renderiza la cuadrícula adaptativa con las primeras 4 instancias de BD o la tarjeta de estado vacío.
// Dónde se conecta: Renderizado al final de OverviewPage.
// De dónde trae datos: Recibe la lista de DatabaseInstance y callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/databases/compact_database_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/databases/overview_empty_databases.dart';

/// Cuadrícula responsiva que organiza las instancias de bases de datos recientes
class OverviewDatabasesGrid extends StatelessWidget {
  const OverviewDatabasesGrid({
    required this.instances, // Lista de instancias de BD del usuario
    required this.onGoDatabases, // Callback para ir a la pestaña de bases de datos
    required this.onCreateDatabase, // Callback para abrir modal de creación
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onGoDatabases;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    final displayedInstances = instances.take(4).toList();

    // 1. Si no hay bases de datos, muestra estado vacío
    if (displayedInstances.isEmpty) {
      return OverviewEmptyDatabases(
        onCreateDatabase: onCreateDatabase,
      );
    }

    // 2. Si existen bases de datos, renderiza la cuadrícula responsiva
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
