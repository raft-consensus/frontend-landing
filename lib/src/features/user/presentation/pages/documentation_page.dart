// ==========================================
// Que hace: Pagina central de Guias que unicamente orquesta el lienzo y la pestana activa.
// De donde trae datos: Renderiza DocumentationServiceSelector y las secciones de cada servicio.
// Donde se conecta: Sexta pestana en DashboardPage (indice 5).
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/ai/ai_guide_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/databases/databases_guide_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/dns/dns_guide_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/layout/documentation_service_selector.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/n8n/n8n_guide_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/tools/tools_guide_section.dart';

/// Pagina de Guias reducida exclusivamente al ensamblaje del lienzo
class ToolsAndDocsPage extends StatefulWidget {
  const ToolsAndDocsPage({
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<ToolsAndDocsPage> createState() => _ToolsAndDocsPageState();
}

class _ToolsAndDocsPageState extends State<ToolsAndDocsPage> {
  int _activeServiceTab = 0; // 0: BDs, 1: DNS & SSL, 2: IA, 3: n8n, 4: Herramientas

  @override
  Widget build(BuildContext context) {
    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Selector segmentado superior modularizado
          DocumentationServiceSelector(
            selectedIndex: _activeServiceTab,
            onSelect: (index) => setState(() => _activeServiceTab = index),
          ),
          const SizedBox(height: 24),

          // 2. Renderizado de la seccion activa
          if (_activeServiceTab == 0)
            DatabasesGuideSection(onMessage: widget.onMessage)
          else if (_activeServiceTab == 1)
            DnsGuideSection(onMessage: widget.onMessage)
          else if (_activeServiceTab == 2)
            AiGuideSection(onMessage: widget.onMessage)
          else if (_activeServiceTab == 3)
            N8nGuideSection(onMessage: widget.onMessage)
          else
            ToolsGuideSection(onMessage: widget.onMessage),
        ],
      ),
    );
  }
}
