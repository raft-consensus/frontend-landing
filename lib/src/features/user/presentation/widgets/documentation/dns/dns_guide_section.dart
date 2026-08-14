// ==========================================
// Que hace: Seccion documental para administracion de dominios, subdominios *.raftdb.dev y certificados SSL.
// De donde trae datos: Coleccion de configuraciones de registros DNS y proxies inversos.
// Donde se conecta: Renderizado como la segunda opcion de servicio en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Seccion de documentacion para Dominio y SSL
class DnsGuideSection extends StatelessWidget {
  const DnsGuideSection({
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
          title: 'Guía de Dominio Dinámico & Certificados SSL',
          subtitle: 'Aprende a exponer tus servicios mediante subdominios seguros con HTTPS automático y proxy inverso',
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
                    title: 'Aprovisionamiento de Subdominios *.raftdb.dev',
                    description: 'Apunta automaticamente cualquier puerto de tu contenedor o base de datos a un subdominio publico.',
                    snippet: '# Ejemplo de resolucion automatica de subdominio\nHost: api-app.raftdb.dev\nTarget: localhost:8080 (o instancia asignada)\nProtocol: HTTPS (Puerto 443)\nTTL: Automatico (300 segundos)',
                    icon: Icons.language_rounded,
                    badgeText: 'DNS Dinámico',
                    badgeColor: AppColors.blue,
                    estimatedTime: '2 min',
                    onMessage: onMessage,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Renovación y Emisión Automática de SSL/TLS',
                    description: 'Certificados emitidos via Let\'s Encrypt con renovacion transparente antes de la fecha de caducidad.',
                    snippet: '// Validacion de certificado SSL en tus clientes HTTP\n// Todos los endpoints creados con *.raftdb.dev incluyen SSL valido A+\ncurl -Iv https://mi-servicio.raftdb.dev/health\n\n// Respuesta de handshake TLS:\n* Server certificate: *.raftdb.dev\n* SSL certificate verify ok.',
                    icon: Icons.lock_outline_rounded,
                    badgeText: 'Let\'s Encrypt',
                    badgeColor: const Color(0xFF10B981),
                    estimatedTime: '3 min',
                    onMessage: onMessage,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Cabeceras de Proxy Inverso y Redirección HTTPS',
                    description: 'El balanceador de carga redirige todo el trafico HTTP a HTTPS e inyecta cabeceras de reenvio.',
                    snippet: '# Cabeceras inyectadas automaticamente a tu backend:\nX-Forwarded-For: <IP_CLIENTE>\nX-Forwarded-Proto: https\nX-Forwarded-Host: mi-subdominio.raftdb.dev\nX-Real-IP: <IP_CLIENTE>',
                    icon: Icons.alt_route_rounded,
                    badgeText: 'Proxy Inverso',
                    badgeColor: const Color(0xFF8B5CF6),
                    estimatedTime: '2 min',
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
