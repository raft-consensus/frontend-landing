import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_management_card.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/empty_databases.dart'; // Databases

/// ¿Qué hace?: Página web de administración de bases de datos con filtros por motor, buscador y lista de instancias.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), widgets de common y widgets de databases.
/// ¿Hacia dónde va / Cómo se conecta?: Es la segunda pestaña renderizada dentro de DashboardPage.
class DatabasesPage extends StatefulWidget {
  const DatabasesPage({
    required this.instances,          // Lista de instancias activas
    required this.onCreateDatabase,   // Callback para abrir el modal de crear BD
    required this.onToggleState,      // Callback para encender/apagar BD
    required this.onDelete,           // Callback para eliminar BD
    required this.onMessage,          // Callback para notificaciones snackbar
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onCreateDatabase;
  final void Function(int index) onToggleState;
  final void Function(int index) onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  State<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends State<DatabasesPage> {
  String _selectedFilter = 'Todos'; // Filtro seleccionado ('Todos', 'PostgreSQL', etc.)
  String _searchQuery = '';          // Cadena del buscador

  @override
  Widget build(BuildContext context) {
    // Filtra las instancias según el motor seleccionado y el buscador
    final filtered = widget.instances.where((instance) {
      final matchesFilter = _selectedFilter == 'Todos' || instance.engine == _selectedFilter;
      final matchesSearch = instance.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          instance.host.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de sección
          SectionHeader(
            title: 'Gestión de Bases de Datos',
            subtitle: 'Administra tus instancias activas, credenciales y motores',
            actionLabel: 'Nueva BD',
            actionIcon: Icons.add_rounded,
            onAction: widget.onCreateDatabase,
          ),
          const SizedBox(height: 20),

          // Barra de Filtros por Motor (Chips gráficos)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todos', 'PostgreSQL', 'MySQL', 'MongoDB', 'SQL Server'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedFilter = filter);
                    },
                    selectedColor: AppColors.navy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Renderizado condicional: Lista de tarjetas de BD o Estado Vacío
          if (filtered.isEmpty)
            EmptyDatabases(onCreateDatabase: widget.onCreateDatabase)
          else
            Column(
              children: filtered.map((instance) {
                final originalIndex = widget.instances.indexOf(instance);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DatabaseManagementCard(
                    instance: instance,
                    onToggleState: () => widget.onToggleState(originalIndex),
                    onDelete: () => widget.onDelete(originalIndex),
                    onMessage: widget.onMessage,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
