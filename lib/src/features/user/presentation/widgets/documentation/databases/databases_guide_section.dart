// ==========================================
// Que hace: Lienzo de documentacion de Bases de Datos con snippets de conexion y hoja de especificaciones/limites reales.
// De donde trae datos: Orquesta DatabasesCodeGuidesGrid y ServiceDocumentSheet.
// Donde se conecta: Primera opcion en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/service_document_sheet.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/databases/databases_code_guides_grid.dart';

/// Lienzo de documentacion para Bases de Datos
class DatabasesGuideSection extends StatelessWidget {
  const DatabasesGuideSection({
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
          title: 'Guías de Conexión a Bases de Datos',
          subtitle: 'Aprende a integrar tus instancias PostgreSQL, MySQL, Redis y MongoDB con tus aplicaciones',
        ),
        const SizedBox(height: 20),

        // 2. Cuadricula de guias de codigo
        DatabasesCodeGuidesGrid(onMessage: onMessage),
        const SizedBox(height: 24),

        // 3. Hoja de especificaciones y limites reales en formato documento
        const ServiceDocumentSheet(
          description: 'Aprovisionamiento de bases de datos relacionales y NoSQL con credenciales independientes y conectividad directa mediante URI.',
          limits: [
            'Hasta 3 bases de datos por cada motor disponible (PostgreSQL, MySQL, Redis y MongoDB).',
            '20 MB de almacenamiento máximo por cada instancia de base de datos.',
          ],
          recommendations: [
            'Conéctate a tus bases de datos mediante clientes externos como DBeaver, pgAdmin o TablePlus.',
            'Mantén seguras tus credenciales y no las expongas en aplicaciones web o móviles públicas.',
          ],
        ),
      ],
    );
  }
}
