// ==========================================
// Qué hace: Barra de herramientas con buscador expandido a todo el ancho y botón "Generar API Key" con separación de 36px.
// Dónde se conecta: Se incluye sobre la tabla principal en AiServicesPage.
// De dónde trae datos: Ingesta callbacks de búsqueda y creación.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/toolbar/ai_toolbar_create_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/toolbar/ai_toolbar_search_field.dart';

/// Barra de herramientas responsiva y homogénea para el servicio de IA
class AiToolbar extends StatelessWidget {
  const AiToolbar({
    required this.onSearchChanged, // Callback al buscar
    required this.onCreateNew, // Callback para crear nueva clave
    super.key,
  });

  final ValueChanged<String> onSearchChanged; // Evento de búsqueda en tiempo real
  final VoidCallback onCreateNew; // Evento de apertura del diálogo de creación

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        // 1. Layout Móvil (< 650px): Buscador y botón en columna
        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AiToolbarSearchField(onSearchChanged: onSearchChanged),
              const SizedBox(height: 12),
              AiToolbarCreateButton(
                onCreateNew: onCreateNew,
                isFullWidth: true,
              ),
            ],
          );
        }

        // 2. Layout Escritorio / Tablet: Buscador expandido y botón con separación de 36px
        return Row(
          children: [
            Expanded(
              child: AiToolbarSearchField(onSearchChanged: onSearchChanged),
            ),
            const SizedBox(width: 36), // Separación amplia idéntica
            AiToolbarCreateButton(
              onCreateNew: onCreateNew,
            ),
          ],
        );
      },
    );
  }
}
