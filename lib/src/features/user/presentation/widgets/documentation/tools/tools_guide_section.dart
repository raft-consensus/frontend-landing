// ==========================================
// Que hace: Catalogo de herramientas y gestores de bases de datos con enlaces oficiales a DBeaver, pgAdmin, TablePlus, etc.
// De donde trae datos: Coleccion de gestores de BD con sus sitios oficiales y parametros.
// Donde se conecta: Renderizado como la quinta opcion de servicio en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/tools/tool_download_card.dart';

/// Catalogo de herramientas de gestion de bases de datos con enlaces directos de descarga
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
        // Encabezado con descripcion breve
        const SectionHeader(
          title: 'Herramientas y Clientes de Bases de Datos',
          subtitle: 'Descarga los gestores visuales mas populares para conectarte a tus instancias de Raft DB de forma segura',
        ),
        const SizedBox(height: 20),

        // Cuadricula responsiva de 3 o 2 columnas segun resolucion
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cols = width >= 1000 ? 3 : (width >= 650 ? 2 : 1);
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
                    category: 'Universal / SQL & NoSQL',
                    description: 'Cliente de escritorio gratuito y multiplataforma compatible con Postgres, MySQL, Redis y MongoDB.',
                    icon: Icons.desktop_windows_rounded,
                    officialUrl: 'https://dbeaver.io/download/',
                    configSnippet: 'Host: pg01.raftdb.dev\nPort: 5432\nDatabase: <tu_db>\nUser: <tu_user>\nSSL: Disable o Allow',
                    onMessage: onMessage,
                  ),
                ),
                // 2. pgAdmin 4
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'pgAdmin 4',
                    category: 'PostgreSQL Oficial',
                    description: 'La herramienta oficial y mas completa para administracion avanzada de servidores PostgreSQL.',
                    icon: Icons.storage_rounded,
                    officialUrl: 'https://www.pgadmin.org/download/',
                    configSnippet: 'General -> Name: Raft DB Postgres\nConnection -> Host: pg01.raftdb.dev\nPort: 5432\nSSL Mode: Prefer',
                    onMessage: onMessage,
                  ),
                ),
                // 3. TablePlus
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'TablePlus',
                    category: 'Moderno & Ultraligero',
                    description: 'Interfaz gráfica nativa, moderna y ultra rapida para gestionar múltiples motores relacionales.',
                    icon: Icons.table_chart_rounded,
                    officialUrl: 'https://tableplus.com/download',
                    configSnippet: 'Host: pg01.raftdb.dev\nPort: 5432\nUser: <tu_user>\nPassword: <tu_pass>\nTLS: Disabled',
                    onMessage: onMessage,
                  ),
                ),
                // 4. MongoDB Compass
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'MongoDB Compass',
                    category: 'NoSQL Oficial',
                    description: 'Explorador visual interactivo oficial para documentos, agregaciones y esquemas MongoDB.',
                    icon: Icons.eco_rounded,
                    officialUrl: 'https://www.mongodb.com/try/download/compass',
                    configSnippet: 'URI de conexion:\nmongodb://usuario:pass@mongo01.raftdb.dev:27017/mi_db?authSource=admin',
                    onMessage: onMessage,
                  ),
                ),
                // 5. MySQL Workbench
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'MySQL Workbench',
                    category: 'MySQL Oficial',
                    description: 'Entorno visual de diseno, modelado, generacion y mantenimiento de bases de datos MySQL.',
                    icon: Icons.dns_rounded,
                    officialUrl: 'https://dev.mysql.com/downloads/workbench/',
                    configSnippet: 'Hostname: mysql01.raftdb.dev\nPort: 3306\nUsername: <tu_user>\nUse SSL: If Available',
                    onMessage: onMessage,
                  ),
                ),
                // 6. Redis Insight
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'Redis Insight',
                    category: 'Clave-Valor / Cache',
                    description: 'Visualizador de claves, memoria, streams y rendimiento en tiempo real para instancias Redis.',
                    icon: Icons.memory_rounded,
                    officialUrl: 'https://redis.io/insight/',
                    configSnippet: 'Host: redis01.raftdb.dev\nPort: 6379\nAuth / Password: <tu_auth_token>',
                    onMessage: onMessage,
                  ),
                ),
                // 7. Prisma Studio
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'Prisma Studio',
                    category: 'Web GUI / ORM',
                    description: 'Panel web integrado para explorar y manipular datos directamente desde tu proyecto Node.js.',
                    icon: Icons.auto_awesome_rounded,
                    officialUrl: 'https://www.prisma.io/studio',
                    configSnippet: '# Ejecuta en la terminal de tu proyecto:\nnpx prisma studio\n# Se abrira en http://localhost:5555',
                    onMessage: onMessage,
                  ),
                ),
                // 8. phpMyAdmin
                SizedBox(
                  width: cardWidth,
                  child: ToolDownloadCard(
                    title: 'phpMyAdmin',
                    category: 'Web GUI / MySQL',
                    description: 'Herramienta web clasica para administracion completa de bases de datos MySQL y MariaDB.',
                    icon: Icons.language_rounded,
                    officialUrl: 'https://www.phpmyadmin.net/downloads/',
                    configSnippet: 'Servidor: mysql01.raftdb.dev\nPuerto: 3306\nTipo de conexion: TCP/IP',
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
