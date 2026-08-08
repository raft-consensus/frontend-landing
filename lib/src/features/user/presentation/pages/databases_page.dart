import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_management_card.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_summary_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/empty_databases.dart'; // Databases

/// ¿Qué hace?: Página web de administración de bases de datos con grilla de 3 columnas responsiva, buscador en tiempo real y filtros.
/// ¿De dónde trae datos?: Recibe instancias de DatabaseInstance y callbacks de gestión desde DashboardPage.
/// ¿Hacia dónde va / Cómo se conecta?: Es la vista de la pestaña "Bases de Datos" en el panel de usuario.
class DatabasesPage extends StatefulWidget {
  const DatabasesPage({
    required this.instances, // Lista de instancias activas
    required this.onCreateDatabase, // Callback para abrir el modal de crear BD
    required this.onToggleState, // Callback para encender/apagar BD
    required this.onDelete, // Callback para eliminar BD
    required this.onMessage, // Callback para notificaciones snackbar
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
  String _selectedFilter =
      'Todos'; // Filtro de motor ('Todos', 'PostgreSQL', etc.)
  final TextEditingController _searchController =
      TextEditingController(); // Controlador del buscador
  String _searchQuery = ''; // Cadena de búsqueda

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filtra las instancias en tiempo real según el motor seleccionado y la consulta de búsqueda
    final filtered = widget.instances.where((instance) {
      final matchesFilter =
          _selectedFilter == 'Todos' || instance.engine == _selectedFilter;
      final matchesSearch =
          instance.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          instance.host.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          instance.database.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesFilter && matchesSearch;
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de sección
          SectionHeader(
            title: 'Gestión de Bases de Datos',
            subtitle:
                'Administra tus instancias activas, credenciales y motores',
            actionLabel: 'Nueva BD',
            actionIcon: Icons.add_rounded,
            onAction: widget.onCreateDatabase,
          ),
          
          const SizedBox(height: 20),
          
          // 2. Tarjeta Resumen de Consumo Total de Almacenamiento
          DatabaseSummaryCard(instances: widget.instances),

          const SizedBox(height: 20),

          // Barra de Búsqueda e Insumo de Filtros
          Row(
            children: [
              // Buscador dinámico por texto
              Expanded(
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    color: isDark
                        ? AppColors.nightTextPrimary
                        : AppColors.dayTextPrimary,
                    fontSize: 13,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, host o base de datos...',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.nightTextSecondary
                          : AppColors.dayTextSecondary,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.nightTextSecondary
                          : AppColors.dayTextSecondary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.cardColor,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chips gráficos de selección por Motor
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['Todos', 'PostgreSQL', 'MySQL', 'MongoDB', 'SQL Server'].map(
                    (filter) {
                      final isSelected = _selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                            }
                          },
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: theme.cardColor,
                          labelStyle: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : (isDark
                                      ? AppColors.nightTextPrimary
                                      : AppColors.dayTextPrimary),
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 12,
                          ),
                          side: BorderSide(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Renderizado condicional: Grilla Responsiva de 3 Columnas o Estado Vacío
          if (filtered.isEmpty)
            EmptyDatabases(onCreateDatabase: widget.onCreateDatabase)
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                // Cálculo responsivo del número de columnas según el ancho disponible
                final int crossAxisCount = width >= 1200
                    ? 3
                    : (width >= 768 ? 2 : 1);
                const double spacing = 16.0;

                // Cálculo exacto del ancho individual de cada tarjeta
                final double itemWidth = crossAxisCount == 1
                    ? width
                    : (width - (spacing * (crossAxisCount - 1))) /
                          crossAxisCount;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: filtered.map((instance) {
                    final originalIndex = widget.instances.indexOf(instance);
                    return SizedBox(
                      width: itemWidth,
                      child: DatabaseManagementCard(
                        instance: instance,
                        onToggleState: () =>
                            widget.onToggleState(originalIndex),
                        onDelete: () => widget.onDelete(originalIndex),
                        onMessage: widget.onMessage,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
