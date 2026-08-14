// ==========================================
// Que hace: Lienzo de documentacion de DNS & SSL con guias de subdominios, certificados y hoja de limites reales.
// De donde trae datos: Orquesta DnsGuidesGrid y ServiceDocumentSheet.
// Donde se conecta: Segunda opcion en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/service_document_sheet.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/dns/dns_guides_grid.dart';

/// Lienzo de documentacion para Dominio y SSL en Raft Cloud
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
        // 1. Encabezado limpio
        const SectionHeader(
          title: 'Guía de Dominio Dinámico & Certificados SSL',
          subtitle: 'Aprende a exponer tus servicios mediante subdominios seguros *.raft.coderhivex.com',
        ),
        const SizedBox(height: 20),

        // 2. Cuadricula modular de 3 columnas
        DnsGuidesGrid(onMessage: onMessage),
        const SizedBox(height: 24),

        // 3. Hoja de especificaciones y limites reales en formato documento
        const ServiceDocumentSheet(
          description: 'Raft Cloud administra registros DNS dinámicos bajo el dominio *.raft.coderhivex.com con resolución directa TCP para bases de datos y soporte SSL para endpoints seguros.',
          offerings: [
            'Aprovisionamiento de subdominios del tipo [subdominio].raft.coderhivex.com.',
            'Resolución DNS de baja latencia con propagación automatizada.',
            'Acceso directo por TCP para puertos de bases de datos relacionales y NoSQL.',
            'Cifrado SSL/TLS para tráfico web y llamadas API HTTPS.',
          ],
          limits: [
            'Hasta 10 registros DNS / subdominios activos simultáneos por cuenta.',
          ],
          recommendations: [
            'Verifica que el nombre de tu subdominio esté en minúsculas y no contenga caracteres especiales ni espacios.',
            'Para bases de datos, utiliza siempre el puerto asignado junto con el hostname FQDN en tu cadena de conexión.',
          ],
        ),
      ],
    );
  }
}
