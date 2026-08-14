// ==========================================
// Que hace: Seccion documental para conectar bases de datos y webhooks en entornos n8n.
// De donde trae datos: Coleccion de configuraciones de integracion n8n.
// Donde se conecta: Renderizado como la cuarta opcion de servicio en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Seccion de documentacion para Workflows n8n
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
        // Encabezado con descripcion breve
        const SectionHeader(
          title: 'Guía de Automatización y Workflows (n8n)',
          subtitle: 'Aprende a conectar tus bases de datos con cientos de aplicaciones externas y disparadores de eventos',
        ),
        const SizedBox(height: 20),

        // Cuadricula responsiva de tarjetas
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cols = width >= 850 ? 2 : 1;
            final cardWidth = (width - (cols - 1) * 16) / cols;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Configurar Credenciales de PostgreSQL en n8n',
                    description: 'Conecta un nodo nativo de base de datos dentro de tu lienzo visual de n8n.',
                    snippet: '// Parametros del nodo Postgres en n8n:\nHost: pg01.raftdb.dev\nDatabase: mi_database\nUser: usuario_raft\nPassword: <tu_password>\nPort: 5432\nSSL: Disable / Allow',
                    icon: Icons.hub_rounded,
                    badgeText: 'Nodo Database',
                    badgeColor: const Color(0xFFEC4899),
                    estimatedTime: '2 min',
                    onMessage: onMessage,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Disparar Flujos mediante Webhooks HTTP',
                    description: 'Recibe notificaciones en tiempo real cuando se inserte un registro en tu base de datos.',
                    snippet: '# Disparo de webhook POST:\ncurl -X POST https://n8n.raftdb.dev/webhook/mi-flujo \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "event": "user.created",\n    "user_id": 1024,\n    "email": "dev@riwi.io"\n  }\'',
                    icon: Icons.webhook_rounded,
                    badgeText: 'Webhook Trigger',
                    badgeColor: const Color(0xFF8B5CF6),
                    estimatedTime: '3 min',
                    onMessage: onMessage,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
