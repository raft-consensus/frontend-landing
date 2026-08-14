// ==========================================
// Que hace: Seccion documental con ejemplos de integracion de modelos LLM mediante API Keys de Raft DB.
// De donde trae datos: Coleccion de snippets compatibles con el estandar OpenAI en Node.js, Python y cURL.
// Donde se conecta: Renderizado como la tercera opcion de servicio en ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/common/doc_expandable_card.dart';

/// Seccion de documentacion para el Servicio de IA
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
        // Encabezado con descripcion breve
        const SectionHeader(
          title: 'Guía de Integración con Modelos de IA',
          subtitle: 'Aprende a consumir endpoints de inferencia y embeddings compatibles con OpenAI usando tu API Key',
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
                    title: 'Llamada HTTP directa con cURL',
                    description: 'Comando de terminal para probar la generacion de texto usando tu clave API.',
                    snippet: 'curl https://api.raft.andrescortes.dev/api/v1/ai/chat/completions \\\n  -H "Content-Type: application/json" \\\n  -H "Authorization: Bearer <TU_API_KEY>" \\\n  -d \'{\n    "model": "deepseek-r1",\n    "messages": [{"role": "user", "content": "Hola mundo"}]\n  }\'',
                    icon: Icons.terminal_rounded,
                    badgeText: 'cURL / REST',
                    badgeColor: const Color(0xFF8B5CF6),
                    estimatedTime: '2 min',
                    onMessage: onMessage,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Integración en Node.js (OpenAI SDK)',
                    description: 'Apunta el baseURL del cliente oficial de OpenAI hacia el servidor de Raft DB.',
                    snippet: "import OpenAI from 'openai';\n\nconst openai = new OpenAI({\n  apiKey: process.env.RAFT_AI_KEY,\n  baseURL: 'https://api.raft.andrescortes.dev/api/v1/ai',\n});\n\nconst response = await openai.chat.completions.create({\n  model: 'llama-3.3-70b',\n  messages: [{ role: 'user', content: 'Explica Raft DB en una linea' }],\n});\n\nconsole.log(response.choices[0].message.content);",
                    icon: Icons.javascript_rounded,
                    badgeText: 'Node.js SDK',
                    badgeColor: const Color(0xFF10B981),
                    estimatedTime: '3 min',
                    onMessage: onMessage,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: DocExpandableCard(
                    title: 'Integración en Python (openai package)',
                    description: 'Configura scripts de Python para procesamiento por lotes o creacion de agentes.',
                    snippet: "from openai import OpenAI\n\nclient = OpenAI(\n    api_key='<TU_API_KEY>',\n    base_url='https://api.raft.andrescortes.dev/api/v1/ai'\n)\n\ncompletion = client.chat.completions.create(\n    model='deepseek-r1',\n    messages=[{'role': 'user', 'content': 'Calcula la raiz cuadrada de 144'}]\n)\n\nprint(completion.choices[0].message.content)",
                    icon: Icons.psychology_rounded,
                    badgeText: 'Python SDK',
                    badgeColor: const Color(0xFFF59E0B),
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
