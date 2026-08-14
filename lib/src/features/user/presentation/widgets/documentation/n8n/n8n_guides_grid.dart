// ==========================================
// Que hace: Cuadricula responsiva de 3 columnas con guias tecnicas para conectar n8n con bases de datos, webhooks y cron jobs.
// De donde trae datos: Parametros de integracion del entorno visual n8n.
// Donde se conecta: Consumido dentro de N8nGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Cuadricula modular con las 3 guias del servicio de Workflows (n8n)
class N8nGuidesGrid extends StatelessWidget {
  const N8nGuidesGrid({
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // 3 columnas en escritorio, 2 en tablets y 1 en moviles
        final cols = width >= 1150 ? 3 : (width >= 720 ? 2 : 1);
        final cardWidth = (width - (cols - 1) * 16) / cols;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // 1. Nodo Postgres / MySQL en n8n
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Conectar Base de Datos en n8n',
                description: 'Configura las credenciales de tu instancia en el nodo oficial Postgres o MySQL.',
                snippet: '// Parametros del nodo en el lienzo n8n:\nHost:     mi-app.raft.coderhivex.com\nDatabase: mi_database\nUser:     usuario_raft\nPassword: password_seguro\nPort:     5432 (o puerto asignado)\nSSL:      allow / disable',
                icon: Icons.storage_rounded,
                badgeText: 'Nodo BD',
                badgeColor: const Color(0xFFEC4899),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 2. Disparador Webhook HTTP
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Disparador Webhook HTTP',
                description: 'Ejecuta flujos automáticos en tiempo real cuando ocurra un evento en tu aplicación.',
                snippet: '# Disparo de webhook mediante cURL / Backend:\ncurl -X POST "https://n8n.raft.coderhivex.com/webhook/mi-flujo" \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "event": "order.created",\n    "user_id": 1024,\n    "total": 89.50\n  }\'',
                icon: Icons.webhook_rounded,
                badgeText: 'Webhook Trigger',
                badgeColor: const Color(0xFF8B5CF6),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 3. Tareas Programadas (Cron / Schedule)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Tareas Programadas (Schedule Trigger)',
                description: 'Programa limpiezas periódicas, sincronizaciones o reportes diarios automáticos.',
                snippet: '// Configuracion del nodo Schedule Trigger:\nIntervalo:   Dias / Horas / Minutos\nHora:        00:00 UTC (Diario)\nAccion nodo: SELECT * FROM users WHERE active = false;\nSalida:      Envio de alerta o exportacion',
                icon: Icons.schedule_send_rounded,
                badgeText: 'Cron / Schedule',
                badgeColor: const Color(0xFF10B981),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),
          ],
        );
      },
    );
  }
}
