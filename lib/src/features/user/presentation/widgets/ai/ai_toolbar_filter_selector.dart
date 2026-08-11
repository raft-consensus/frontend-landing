// ==========================================
// Qué hace: Selector segmentado (SegmentedButton) para filtrar API Keys por estado (Activas, Todas, Revocadas).
// Dónde se conecta: Consumido por AiToolbar.
// De dónde trae datos: Recibe el estado actual del filtro (AiKeyFilter) y el callback onFilterChanged.
// ==========================================

import 'package:flutter/material.dart';

/// Enum global para definir el filtro de estado de las API Keys
enum AiKeyFilter { active, all, revoked }

/// Componente atómico con botones segmentados para cambiar el filtro de visualización
class AiToolbarFilterSelector extends StatelessWidget {
  const AiToolbarFilterSelector({
    required this.selectedFilter,   // Filtro de estado actualmente seleccionado
    required this.onFilterChanged,  // Callback al seleccionar una pestaña de filtro
    super.key,
  });

  final AiKeyFilter selectedFilter;                 // Atributo con el filtro activo
  final ValueChanged<AiKeyFilter> onFilterChanged;  // Evento de cambio de filtro

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AiKeyFilter>(
      segments: const [
        ButtonSegment(
          value: AiKeyFilter.active,
          label: Text('Activas'),
          icon: Icon(Icons.check_circle_outline, size: 16),
        ),
        ButtonSegment(
          value: AiKeyFilter.all,
          label: Text('Todas'),
          icon: Icon(Icons.list_alt_rounded, size: 16),
        ),
        ButtonSegment(
          value: AiKeyFilter.revoked,
          label: Text('Revocadas'),
          icon: Icon(Icons.block_rounded, size: 16),
        ),
      ],
      selected: {selectedFilter},
      onSelectionChanged: (newSelection) => onFilterChanged(newSelection.first),
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
