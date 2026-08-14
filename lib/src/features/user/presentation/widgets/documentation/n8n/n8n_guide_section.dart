// ==========================================
// Que hace: Lienzo de documentacion de Workflows n8n con guias de integracion y hoja de limites reales.
// De donde trae datos: Orquesta N8nGuidesGrid y ServiceDocumentSheet.
// Donde se conecta: Cuarta opcion en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/service_document_sheet.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/n8n/n8n_guides_grid.dart';

/// Lienzo de documentacion para el Servicio de Automatización (n8n)
class N8nGuideSection extends StatelessWidget {
  const N8nGuideSection({
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
          title: 'Guía de Automatización y Workflows (n8n)',
          subtitle: 'Aprende a conectar tus bases de datos con cientos de aplicaciones externas y disparadores de eventos',
        ),
        const SizedBox(height: 20),

        // 2. Cuadricula modular de 3 columnas
        N8nGuidesGrid(onMessage: onMessage),
        const SizedBox(height: 24),

        // 3. Hoja de especificaciones y limites reales en formato documento
        const ServiceDocumentSheet(
          description: 'Raft Cloud se integra con la célula de automatización n8n para permitir la creación de flujos de trabajo visuales basados en eventos, webhooks y consultas programadas a tus bases de datos.',
          offerings: [
            'Lienzo visual interactivo para orquestar microservicios y bases de datos.',
            'Nodos oficiales compatibles con PostgreSQL, MySQL, Redis y MongoDB.',
            'Webhooks públicos listos para recibir eventos de tus aplicaciones.',
            'Plantillas prediseñadas para alertas, sincronizaciones y respaldos.',
          ],
          limits: [
            'Hasta 10 workflows activos por cuenta de usuario.',
            'Servicio gestionado externamente por la célula de automatización.',
          ],
          recommendations: [
            'Utiliza el nodo de base de datos correspondiente con las credenciales FQDN de tu instancia en Raft Cloud.',
            'Configura autenticación por cabecera o secreto en tus Webhooks para proteger los flujos públicos.',
            'Si requieres ampliar tu límite de ejecuciones mensuales, solicita soporte a través del canal oficial.',
          ],
        ),
      ],
    );
  }
}
