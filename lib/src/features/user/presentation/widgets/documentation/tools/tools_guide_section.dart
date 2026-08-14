// ==========================================
// Que hace: Lienzo de Herramientas y Ecosistema que orquesta el banner de Docusaurus y el catalogo de software oficial.
// De donde trae datos: Orquesta OfficialDocsBanner y ToolsGrid.
// Donde se conecta: Quinta opcion en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/tools/official_docs_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/tools/tools_grid.dart';

/// Lienzo de Herramientas del Ecosistema Raft Cloud
class ToolsGuideSection extends StatelessWidget {
  const ToolsGuideSection({
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Encabezado limpio
        const SectionHeader(
          title: 'Herramientas y Ecosistema de Desarrollo',
          subtitle: 'Descarga software recomendado para administrar bases de datos, consumir APIs y trabajar con Raft Cloud',
        ),
        const SizedBox(height: 20),

        // 2. Banner especial de documentacion oficial (Docusaurus)
        OfficialDocsBanner(onMessage: onMessage),
        const SizedBox(height: 24),

        // 3. Cuadricula modular de 6 herramientas en filas de 3
        ToolsGrid(onMessage: onMessage),
      ],
    );
  }
}
