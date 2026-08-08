import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/database_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/service_tech_badge.dart';

/// ¿Qué hace?: Sección principal que presenta los 4 servicios integrados del ecosistema Raft Cloud.
/// ¿De dónde trae datos?: Compone las 4 instancias de DatabaseCard con sus logos de motores y tecnologías.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye directamente como tercera sección en LandingPage.
class DatabaseSection extends StatelessWidget {
  const DatabaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          // Título estandarizado de la sección de servicios
          const SectionTitle(
            eyebrow: 'SERVICIOS DEL ECOSISTEMA',
            title: 'Todo lo que necesitas en un solo lugar',
            subtitle:
                'Instancias de bases de datos, gestión DNS con SSL, API Keys de IA y flujos n8n listos para usar.',
          ),
          const SizedBox(height: 42),

          // Grilla responsiva de 4 tarjetas detalladas de servicios
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // Distribución responsiva: 2 columnas en escritorio (>850px) para dar más espacio a los detalles, 1 en móvil
              final cardWidth = width > 850
                  ? (width - 24) / 2
                  : width;

              return Wrap(
                spacing: 24,
                runSpacing: 24,
                children: [
                  // Servicio 1: Bases de Datos con Logos de los 4 motores
                  DatabaseCard(
                    width: cardWidth,
                    name: 'Bases de datos',
                    type: 'Motores SQL y NoSQL Administrados',
                    description:
                        'Aprovisiona instancias con credenciales privadas, usuarios dedicados y monitoreo en tiempo real.',
                    color: AppColors.postgresDay,
                    icon: Icons.storage_rounded,
                    techBadges: const [
                      ServiceTechBadge(label: 'MySQL', assetPath: 'lib/src/img/in/mysql.png'),
                      ServiceTechBadge(label: 'PostgreSQL', assetPath: 'lib/src/img/in/postgresql.png'),
                      ServiceTechBadge(label: 'SQL Server', assetPath: 'lib/src/img/in/sqlserver.png'),
                      ServiceTechBadge(label: 'MongoDB', assetPath: 'lib/src/img/in/mongodb.png'),
                    ],
                  ),

                  // Servicio 2: DNS & Subdominios
                  DatabaseCard(
                    width: cardWidth,
                    name: 'DNS & Subdominios',
                    type: 'Gestión de Red con Cloudflare',
                    description:
                        'Crea subdominios personalizados con apuntamiento CNAME/A y certificados SSL/TLS automáticos.',
                    color: const Color(0xFF2C7BC9),
                    icon: Icons.language_rounded,
                    techBadges: const [
                      ServiceTechBadge(label: 'Cloudflare', icon: Icons.cloud_queue_rounded, color: Color(0xFFF38020)),
                      ServiceTechBadge(label: 'SSL Automático', icon: Icons.lock_outline_rounded, color: AppColors.success),
                      ServiceTechBadge(label: 'Registros A/CNAME', icon: Icons.dns_rounded, color: Color(0xFF2C7BC9)),
                    ],
                  ),

                  // Servicio 3: API Keys de Inteligencia Artificial
                  DatabaseCard(
                    width: cardWidth,
                    name: 'API Keys de IA',
                    type: 'Modelos de Lenguaje y Visión',
                    description:
                        'Genera credenciales para consumir modelos de IA generativa e integrarlos directamente en tus apps.',
                    color: const Color(0xFF2F9E6D),
                    icon: Icons.auto_awesome_rounded,
                    techBadges: const [
                      ServiceTechBadge(label: 'LLM Generativos', icon: Icons.psychology_rounded, color: Color(0xFF9C27B0)),
                      ServiceTechBadge(label: 'API Key Directa', icon: Icons.key_rounded, color: Color(0xFF2F9E6D)),
                      ServiceTechBadge(label: 'Prompt Ready', icon: Icons.chat_bubble_outline_rounded, color: AppColors.cyan),
                    ],
                  ),

                  // Servicio 4: Workflows N8N
                  DatabaseCard(
                    width: cardWidth,
                    name: 'Automatización n8n',
                    type: 'Orquestación de Flujos No-Code',
                    description:
                        'Conecta webhooks, APIs externas, bases de datos y pipelines de automatización en una instancia privada.',
                    color: const Color(0xFFF28C28),
                    icon: Icons.account_tree_rounded,
                    techBadges: const [
                      ServiceTechBadge(label: 'Nodos N8N', icon: Icons.alt_route_rounded, color: Color(0xFFEA4B71)),
                      ServiceTechBadge(label: 'Webhooks', icon: Icons.webhook_rounded, color: Color(0xFFF28C28)),
                      ServiceTechBadge(label: 'Tareas Cron', icon: Icons.schedule_rounded, color: AppColors.cyan),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
