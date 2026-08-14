// ==========================================
// Qué hace: Barra de herramientas integrada para DNS con buscador expandido y botón "+ Nuevo Subdominio".
// Dónde se conecta: Se incluye en DnsSslPage sobre la tabla de subdominios.
// De dónde trae datos: Recibe callbacks de búsqueda y creación.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/toolbar/dns_create_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/toolbar/dns_search_field.dart';

/// Barra de herramientas responsiva para el módulo DNS
class DnsToolbar extends StatelessWidget {
  const DnsToolbar({
    required this.onSearchChanged, // Callback al buscar
    required this.onCreateNew, // Callback para crear nuevo subdominio
    super.key,
  });

  final ValueChanged<String> onSearchChanged; // Evento de búsqueda
  final VoidCallback onCreateNew; // Evento de creación

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DnsSearchField(onSearchChanged: onSearchChanged),
              const SizedBox(height: 12),
              DnsCreateButton(onCreateNew: onCreateNew, isFullWidth: true),
            ],
          );
        }

        return Row(
          children: [
            // 1. Buscador expandido a todo el ancho disponible
            Expanded(
              child: DnsSearchField(onSearchChanged: onSearchChanged),
            ),
            const SizedBox(width: 36), // Separación amplia

            // 2. Botón de creación
            DnsCreateButton(onCreateNew: onCreateNew),
          ],
        );
      },
    );
  }
}
