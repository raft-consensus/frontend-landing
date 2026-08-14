// ==========================================
// Que hace: Vista principal limpia de Bases de Datos sin encabezados redundantes.
// De donde trae datos: Escucha userDatabasesProvider via Riverpod.
// Donde se conecta: Renderizado en el indice 1 del IndexedStack en DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/actions/database_create_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/summary/database_summary_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/toolbar/database_toolbar.dart';

/// Vista modular de administracion de bases de datos
class DatabasesPage extends ConsumerStatefulWidget {
  const DatabasesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage; // Callback para notificaciones

  @override
  ConsumerState<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends ConsumerState<DatabasesPage> {
  String _selectedEngine = 'Todos'; // Filtro de motor activo
  String _selectedStatus = 'Todas'; // Filtro de estado activo ('Todas', 'Activas', 'Pausadas')
  String _searchQuery = ''; // Cadena de busqueda en tiempo real

  @override
  Widget build(BuildContext context) {
    final instances = ref.watch(userDatabasesProvider); // Instancias desde Riverpod

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Modulo de Resumen KPI de Almacenamiento directo (sin titulo redundante)
          DatabaseSummaryCard(instances: instances),
          const SizedBox(height: 20),

          // 2. Barra de Herramientas (Buscador, Boton Crear y Filtros)
          DatabaseToolbar(
            selectedEngine: _selectedEngine,
            selectedStatus: _selectedStatus,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onEngineChanged: (e) => setState(() => _selectedEngine = e),
            onStatusChanged: (s) => setState(() => _selectedStatus = s),
            onCreateNew: () => DatabaseCreateAction.execute(
              context: context,
              ref: ref,
              onMessage: widget.onMessage,
            ),
          ),
          const SizedBox(height: 24),

          // 3. Cuadricula de bases de datos con sus parametros completos
          DatabaseGrid(
            instances: instances,
            selectedEngine: _selectedEngine,
            selectedStatus: _selectedStatus,
            searchQuery: _searchQuery,
            onCreate: () => DatabaseCreateAction.execute(
              context: context,
              ref: ref,
              onMessage: widget.onMessage,
            ),
            onMessage: widget.onMessage,
          ),
        ],
      ),
    );
  }
}
