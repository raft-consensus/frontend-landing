// ==========================================
// Que hace: Lienzo de documentacion del Servicio de IA con guias de Warp, Python, cURL y limites reales de API Keys.
// De donde trae datos: Orquesta AiGuidesGrid y ServiceDocumentSheet.
// Donde se conecta: Tercera opcion en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/ai/ai_guides_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/service_document_sheet.dart';

/// Lienzo de documentacion para el Servicio de IA de Raft Cloud
class AiGuideSection extends StatelessWidget {
  const AiGuideSection({
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
          title: 'Guía del Servicio de Inteligencia Artificial',
          subtitle: 'Aprende a integrar el proxy de inferencia OpenAI-Compatible con Warp Terminal, Python y tus aplicaciones',
        ),
        const SizedBox(height: 20),

        // 2. Cuadricula modular de 3 columnas
        AiGuidesGrid(onMessage: onMessage),
        const SizedBox(height: 24),

        // 3. Hoja de especificaciones y limites reales en formato documento
        const ServiceDocumentSheet(
          description: 'Raft Cloud ofrece un proxy de inferencia de IA 100% compatible con el estándar OpenAI v1. Puedes consumir el modelo llama-8b-nvidia directamente en tu terminal, scripts o backends.',
          offerings: [
            'Endpoint base compatible con OpenAI: https://api.coderhivex.com/v1.',
            'Modelo oficial predeterminado: llama-8b-nvidia.',
            'Rotación instantánea de claves conservando métricas de consumo histórico.',
            'Seguimiento en vivo de peticiones totales y tokens procesados.',
          ],
          limits: [
            'Hasta 10 API Keys activas simultáneas por cuenta.',
          ],
          recommendations: [
            'Para conectar con Warp Terminal: dirígete a Settings > AI, selecciona Custom OpenAI Provider con Base URL https://api.coderhivex.com/v1 y modelo llama-8b-nvidia.',
            'Almacena siempre tus claves en variables de entorno (.env) y nunca las subas a repositorios de código abiertos.',
            'Si sospechas que una clave fue filtrada, utiliza la opción "Rotar" desde el panel de IA para generar un nuevo secreto al instante.',
          ],
        ),
      ],
    );
  }
}
