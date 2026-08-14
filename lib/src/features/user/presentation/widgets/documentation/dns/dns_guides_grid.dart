// ==========================================
// Que hace: Cuadricula responsiva de 3 columnas con guias tecnicas sobre resolucion DNS, conexion TCP directa y SSL.
// De donde trae datos: Parametros reales de Raft Cloud bajo el dominio *.raft.coderhivex.com.
// Donde se conecta: Consumido dentro de DnsGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Cuadricula modular con las 3 guias de DNS & SSL para Raft Cloud
class DnsGuidesGrid extends StatelessWidget {
  const DnsGuidesGrid({
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
            // 1. Resolucion DNS del subdominio
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Resolución DNS (*.raft.coderhivex.com)',
                description: 'Los subdominios generados resuelven hacia la IP pública de tu instancia en Raft Cloud.',
                snippet: '# Consulta de resolucion DNS en terminal:\nnslookup mi-app.raft.coderhivex.com\n\n# Respuesta esperada:\n# Name:    mi-app.raft.coderhivex.com\n# Address: <IP_PUBLICA_ASIGNADA>',
                icon: Icons.language_rounded,
                badgeText: 'DNS Dinámico',
                badgeColor: AppColors.dayAccent,
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 2. Conexion Directa TCP para Bases de Datos
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Conexión Directa TCP (Sin Proxy)',
                description: 'Tus bases de datos se comunican por TCP directo en sus puertos nativos (5432, 3306, etc.).',
                snippet: '# Verificacion de conectividad al puerto TCP:\nnc -zv mi-app.raft.coderhivex.com 5432\n\n# Conexion directa con cliente oficial:\npsql -h mi-app.raft.coderhivex.com -p 5432 -U usuario_raft -d mi_database',
                icon: Icons.alt_route_rounded,
                badgeText: 'Direct TCP',
                badgeColor: const Color(0xFF10B981),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 3. Certificados SSL/TLS para APIs Web
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Cifrado SSL / TLS para APIs',
                description: 'Tus endpoints y servicios web cuentan con certificados SSL gestionados bajo *.coderhivex.com.',
                snippet: '# Comprobacion de handshake SSL y estado HTTP:\ncurl -Iv https://mi-app.raft.coderhivex.com/health\n\n# Respuesta segura:\n* Server certificate: *.coderhivex.com\n* SSL certificate verify ok\n* HTTP/2 200 OK',
                icon: Icons.lock_outline_rounded,
                badgeText: 'HTTPS / SSL',
                badgeColor: const Color(0xFF8B5CF6),
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
