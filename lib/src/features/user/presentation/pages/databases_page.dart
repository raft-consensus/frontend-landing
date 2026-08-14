// ==========================================
// Qué hace: Vista principal limpia de Bases de Datos que solo ensambla los módulos segmentados.
// Dónde se conecta: Se renderiza en el índice 1 del IndexedStack en DashboardPage.
// De dónde trae datos: Escucha userDatabasesProvider vía Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/actions/database_create_action.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/cards/database_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/summary/database_summary_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/toolbar/database_toolbar.dart';

/// Vista modular de administración de bases de datos
class DatabasesPage extends ConsumerStatefulWidget {
  const DatabasesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage; // Callback para emitir notificaciones

  @override
  ConsumerState<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends ConsumerState<DatabasesPage> {
  String _selectedEngine = 'Todos'; // Filtro de motor activo
  String _selectedStatus = 'Todas'; // Filtro de estado activo ('Todas', 'Activas', 'Pausadas')
  String _searchQuery = ''; // Cadena de búsqueda en tiempo real

  @override
  Widget build(BuildContext context) {
    final instances = ref.watch(userDatabasesProvider); // Instancias desde Riverpod

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado limpio de la sección
          const SectionHeader(
            title: 'Gestión de Bases de Datos',
            subtitle: 'Administra tus instancias activas, credenciales y motores',
          ),
          const SizedBox(height: 20),

          // 2. Módulo de Resumen KPI de Almacenamiento
          DatabaseSummaryCard(instances: instances),
          const SizedBox(height: 20),

          // 3. Módulo de Barra de Herramientas (Buscador acotado, Botón Crear al lado y Chips de filtro)
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

          // 4. Módulo de Grilla de Tarjetas
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
