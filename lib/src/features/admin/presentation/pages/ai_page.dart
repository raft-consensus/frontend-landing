import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/ai_workspace.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/filter_bar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/empty_state.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/ai/ai_workspace_card.dart'; // Widget

/// ¿Qué hace?: Módulo administrativo del servicio de IA (inferencia / LLMs)
/// que expone la plataforma Raft DB dentro del clúster federado.
/// ¿De dónde trae?: Recibe la lista de workspaces desde AdminDashboard.
/// ¿Hacia dónde va?: Se registra como sección del sidebar administrativo.
class AiPage extends StatefulWidget {
  const AiPage({
    required this.workspaces,
    required this.onToggle,
    required this.onDelete,
    required this.onDetails,
    required this.onMessage,
    super.key,
  });

  final List<AiWorkspace> workspaces;
  final ValueChanged<AiWorkspace> onToggle;
  final ValueChanged<AiWorkspace> onDelete;
  final ValueChanged<AiWorkspace> onDetails;
  final void Function(String, {bool success}) onMessage;

  @override
  State<AiPage> createState() => _AiPageState();
}

class _AiPageState extends State<AiPage> {
  String _query = '';
  String _provider = 'Todos';

  List<AiWorkspace> get filtered {
    return widget.workspaces.where((workspace) {
      final query = _query.toLowerCase();

      return (workspace.name.toLowerCase().contains(query) ||
              workspace.owner.toLowerCase().contains(query)) &&
          (_provider == 'Todos' || workspace.provider == _provider);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Servicio de IA',
            subtitle:
                'Supervisa los workspaces de inferencia (LLMs) asignados '
                'a cada usuario en el clúster.',
            action: 'Exportar listado',
            actionIcon: Icons.download_rounded,
            onAction: () => widget.onMessage(
              'El listado se está exportando.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar workspace o propietario...',
            selectedFilter: _provider,
            filters: const [
              'Todos',
              'OpenAI-compatible',
              'Modelo local (self-hosted)',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _provider = value),
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.smart_toy_rounded,
              title: 'No encontramos workspaces de IA',
              description: 'Prueba con otro filtro o término de búsqueda.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 950
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filtered
                      .map(
                        (workspace) => AiWorkspaceCard(
                          width: cardWidth,
                          workspace: workspace,
                          onDetails: () => widget.onDetails(workspace),
                          onToggle: () => widget.onToggle(workspace),
                          onDelete: () => widget.onDelete(workspace),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}
