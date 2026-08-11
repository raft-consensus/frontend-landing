// ==========================================
// Qué hace: Barra de herramientas responsiva que coordina el buscador, el selector de filtros y el botón de creación.
// Dónde se conecta: Se incluye sobre la tabla principal en AiServicesPage.
// De dónde trae datos: Ingesta cuota de claves, filtro activo, callbacks de búsqueda y de creación.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar_create_button.dart'; // Componente Botón
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar_filter_selector.dart'; // Componente Filtros
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar_search_field.dart'; // Componente Buscador

// Re-exporta el enum para uso conveniente en AiServicesPage
export 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_toolbar_filter_selector.dart' show AiKeyFilter;

/// Barra de herramientas responsiva con adaptabilidad según el ancho de la pantalla
class AiToolbar extends StatelessWidget {
  const AiToolbar({
    required this.keyCount,            // Cantidad actual de claves
    required this.selectedFilter,      // Filtro de estado seleccionado
    required this.onFilterChanged,     // Callback al cambiar de filtro
    required this.onSearchChanged,     // Callback al buscar
    required this.onCreateNew,         // Callback para crear nueva clave
    this.maxKeys = 10,                 // Límite máximo de claves
    super.key,
  });

  final int keyCount;                               // Atributo con el conteo de claves
  final int maxKeys;                                // Atributo con el máximo permitido
  final AiKeyFilter selectedFilter;                 // Atributo con el filtro seleccionado
  final ValueChanged<AiKeyFilter> onFilterChanged;  // Evento de cambio de filtro
  final ValueChanged<String> onSearchChanged;       // Evento de búsqueda
  final VoidCallback onCreateNew;                   // Evento de creación

  @override
  Widget build(BuildContext context) {
    final isLimitReached = keyCount >= maxKeys; // Evalúa si se alcanzó el límite

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 850;

        // 1. Layout para Pantallas Pequeñas / Móviles (< 600px)
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AiToolbarSearchField(onSearchChanged: onSearchChanged),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: AiToolbarFilterSelector(
                  selectedFilter: selectedFilter,
                  onFilterChanged: onFilterChanged,
                ),
              ),
              const SizedBox(height: 12),
              AiToolbarCreateButton(
                isLimitReached: isLimitReached,
                onCreateNew: onCreateNew,
                isFullWidth: true,
              ),
            ],
          );
        }

        // 2. Layout para Tablets (600px - 850px)
        if (isTablet) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(child: AiToolbarSearchField(onSearchChanged: onSearchChanged)),
                  const SizedBox(width: 12),
                  AiToolbarFilterSelector(
                    selectedFilter: selectedFilter,
                    onFilterChanged: onFilterChanged,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AiToolbarCreateButton(
                    isLimitReached: isLimitReached,
                    onCreateNew: onCreateNew,
                  ),
                ],
              ),
            ],
          );
        }

        // 3. Layout para Escritorio (>= 850px)
        return Row(
          children: [
            Expanded(child: AiToolbarSearchField(onSearchChanged: onSearchChanged)),
            const SizedBox(width: 16),
            AiToolbarFilterSelector(
              selectedFilter: selectedFilter,
              onFilterChanged: onFilterChanged,
            ),
            const SizedBox(width: 16),
            AiToolbarCreateButton(
              isLimitReached: isLimitReached,
              onCreateNew: onCreateNew,
            ),
          ],
        );
      },
    );
  }
}
