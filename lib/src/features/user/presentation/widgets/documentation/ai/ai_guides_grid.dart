// ==========================================
// Que hace: Cuadricula responsiva de 3 columnas con guias tecnicas para consumir el proxy de IA en Warp Terminal, Python y cURL.
// De donde trae datos: Especificaciones de endpoint y modelo oficial de Raft Cloud (llama-8b-nvidia).
// Donde se conecta: Consumido dentro de AiGuideSection.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Cuadricula modular con las 3 guias del Servicio de IA
class AiGuidesGrid extends StatelessWidget {
  const AiGuidesGrid({
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
            // 1. Integracion con Warp Terminal & IDEs
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Warp Terminal & Cursor IDE',
                description: 'Configura la IA de Warp o Cursor usando el proxy OpenAI-Compatible de Raft.',
                snippet: '# En Warp: Settings > AI > OpenAI API Key\n# O proveedor personalizado:\nBase URL: https://api.coderhivex.com/v1\nAPI Key:  rk_live_tu_clave_aqui\nModelo:   llama-8b-nvidia',
                icon: Icons.terminal_rounded,
                badgeText: 'Warp / IDE',
                badgeColor: const Color(0xFF06B6D4),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 2. Python (SDK Oficial OpenAI)
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Python (openai package)',
                description: 'Usa la biblioteca estándar de OpenAI apuntando el base_url hacia Raft Cloud.',
                snippet: 'from openai import OpenAI\n\nclient = OpenAI(\n    base_url="https://api.coderhivex.com/v1",\n    api_key="rk_live_tu_clave_aqui",\n)\n\nresponse = client.chat.completions.create(\n    model="llama-8b-nvidia",\n    messages=[{"role": "user", "content": "Explica Raft Cloud"}],\n)\n\nprint(response.choices[0].message.content)',
                icon: Icons.psychology_rounded,
                badgeText: 'Python SDK',
                badgeColor: const Color(0xFFF59E0B),
                estimatedTime: '2 min',
                onMessage: onMessage,
              ),
            ),

            // 3. cURL / Peticion HTTP Directa
            SizedBox(
              width: cardWidth,
              child: DocExpandableCard(
                title: 'Petición HTTP Directa (cURL)',
                description: 'Llamada REST directa al endpoint /chat/completions con cabecera Authorization Bearer.',
                snippet: 'curl -X POST "https://api.coderhivex.com/v1/chat/completions" \\\n  -H "Authorization: Bearer rk_live_tu_clave_aqui" \\\n  -H "Content-Type: application/json" \\\n  -d \'{\n    "model": "llama-8b-nvidia",\n    "messages": [{"role": "user", "content": "Hola mundo"}]\n  }\'',
                icon: Icons.auto_awesome_rounded,
                badgeText: 'REST / cURL',
                badgeColor: const Color(0xFF8B5CF6),
                estimatedTime: '1 min',
                onMessage: onMessage,
              ),
            ),
          ],
        );
      },
    );
  }
}
