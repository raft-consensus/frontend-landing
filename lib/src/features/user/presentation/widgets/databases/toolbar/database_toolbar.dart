// ==========================================
// Qué hace: Barra de herramientas integrada con buscador expandido, botón al lado y chips de filtro.
// Dónde se conecta: Se incluye en DatabasesPage sobre la grilla de instancias.
// De dónde trae datos: Recibe estados de filtro y callbacks de búsqueda/creación.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/toolbar/database_create_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/toolbar/database_filter_chips.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/toolbar/database_search_field.dart';

/// Barra de herramientas completa y responsiva de bases de datos
class DatabaseToolbar extends StatelessWidget {
  const DatabaseToolbar({
    required this.selectedEngine, // Motor seleccionado
    required this.selectedStatus, // Estado seleccionado
    required this.onSearchChanged, // Callback al buscar
    required this.onEngineChanged, // Callback al cambiar motor
    required this.onStatusChanged, // Callback al cambiar estado
    required this.onCreateNew, // Callback para crear nueva BD
    super.key,
  });

  final String selectedEngine; // Motor activo
  final String selectedStatus; // Estado activo
  final ValueChanged<String> onSearchChanged; // Evento de búsqueda
  final ValueChanged<String> onEngineChanged; // Evento cambio motor
  final ValueChanged<String> onStatusChanged; // Evento cambio estado
  final VoidCallback onCreateNew; // Evento creación

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 650;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fila superior: Buscador expandido y Botón Crear BD
            if (isMobile) ...[
              DatabaseSearchField(onSearchChanged: onSearchChanged),
              const SizedBox(height: 12),
              DatabaseCreateButton(onCreateNew: onCreateNew, isFullWidth: true),
            ] else ...[
              Row(
                children: [
                  // 1. Buscador expandido
                  Expanded(
                    child: DatabaseSearchField(onSearchChanged: onSearchChanged),
                  ),
                  const SizedBox(width: 36), // Separación amplia

                  // 2. Botón Crear BD con altura de 44px
                  DatabaseCreateButton(onCreateNew: onCreateNew),
                ],
              ),
            ],
            const SizedBox(height: 16),

            // Fila inferior: Chips de filtrado rápido
            DatabaseFilterChips(
              selectedEngine: selectedEngine,
              selectedStatus: selectedStatus,
              onEngineChanged: onEngineChanged,
              onStatusChanged: onStatusChanged,
            ),
          ],
        );
      },
    );
  }
}
