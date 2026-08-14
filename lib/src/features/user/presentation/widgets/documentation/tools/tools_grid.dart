// ==========================================
// Que hace: Cuadricula responsiva de 3 columnas con las 6 herramientas recomendadas del ecosistema Raft.
// De donde trae datos: Coleccion de enlaces oficiales y parametros de conexion.
// Donde se conecta: Consumido dentro de ToolsGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/tools/tool_download_card.dart';

/// Cuadricula modular con las 6 herramientas oficiales
class ToolsGrid extends StatelessWidget {
  const ToolsGrid({
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
            // 1. DBeaver Community
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'DBeaver Community',
                category: 'Bases de Datos / Universal',
                description: 'Cliente de escritorio universal y multiplataforma compatible con Postgres, MySQL, Redis y MongoDB.',
                icon: Icons.desktop_windows_rounded,
                officialUrl: 'https://dbeaver.io/download/',
                configSnippet: 'Host: mi-app.raft.coderhivex.com\nPort: 5432 / 3306\nDriver: PostgreSQL / MySQL\nSSL Mode: Disable o Prefer',
                onMessage: onMessage,
              ),
            ),

            // 2. pgAdmin 4
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'pgAdmin 4',
                category: 'PostgreSQL Oficial',
                description: 'La herramienta oficial y más completa para administración avanzada y monitoreo de instancias PostgreSQL.',
                icon: Icons.storage_rounded,
                officialUrl: 'https://www.pgadmin.org/download/',
                configSnippet: 'Host: mi-app.raft.coderhivex.com\nPort: 5432\nMaintenance DB: mi_database\nUsername: usuario_raft\nSSL Mode: Prefer',
                onMessage: onMessage,
              ),
            ),

            // 3. MongoDB Compass
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'MongoDB Compass',
                category: 'NoSQL / MongoDB',
                description: 'Explorador visual interactivo oficial para documentos JSON, índices y pipelines de agregación.',
                icon: Icons.eco_rounded,
                officialUrl: 'https://www.mongodb.com/try/download/compass',
                configSnippet: 'URI de conexion:\nmongodb://usuario_raft:password@mi-app.raft.coderhivex.com:27017/mi_database?authSource=admin',
                onMessage: onMessage,
              ),
            ),

            // 4. Postman
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'Postman',
                category: 'APIs & Servicio de IA',
                description: 'Plataforma líder para diseñar, probar y enviar peticiones HTTP REST a tus APIs y al proxy de IA.',
                icon: Icons.send_rounded,
                officialUrl: 'https://www.postman.com/downloads/',
                configSnippet: 'Method: POST\nURL: https://api.coderhivex.com/v1/chat/completions\nHeader: Authorization: Bearer <TU_API_KEY>',
                onMessage: onMessage,
              ),
            ),

            // 5. Warp Terminal
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'Warp Terminal',
                category: 'Terminal con IA',
                description: 'Terminal moderno de alto rendimiento con autocompletado y chat asistido integrado con tu API Key.',
                icon: Icons.terminal_rounded,
                officialUrl: 'https://www.warp.dev/',
                configSnippet: 'Settings > AI > Custom OpenAI Provider\nBase URL: https://api.coderhivex.com/v1\nModelo: llama-8b-nvidia',
                onMessage: onMessage,
              ),
            ),

            // 6. Docker Desktop
            SizedBox(
              width: cardWidth,
              child: ToolDownloadCard(
                title: 'Docker Desktop',
                category: 'Contenedores Locales',
                description: 'Entorno para ejecutar contenedores locales, probar microservicios y sincronizar con n8n.',
                icon: Icons.layers_rounded,
                officialUrl: 'https://www.docker.com/products/docker-desktop/',
                configSnippet: '# Prueba de conexion local:\ndocker run -d --name mi-servicio -p 8080:80 nginx:alpine',
                onMessage: onMessage,
              ),
            ),
          ],
        );
      },
    );
  }
}
