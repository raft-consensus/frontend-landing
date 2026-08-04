import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/n8n_instance.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/admin_scroll_view.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/section_title.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/filter_bar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/empty_state.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/n8n/n8n_instance_card.dart'; // Widget

/// ¿Qué hace?: Módulo administrativo del servicio de automatización N8N
/// que expone la plataforma Raft DB dentro del clúster federado.
/// ¿De dónde trae?: Recibe la lista de instancias desde AdminDashboard.
/// ¿Hacia dónde va?: Se registra como sección del sidebar administrativo.
class N8nPage extends StatefulWidget {
  const N8nPage({
    required this.instances,
    required this.onToggle,
    required this.onDelete,
    required this.onDetails,
    required this.onMessage,
    super.key,
  });

  final List<N8nInstance> instances;
  final ValueChanged<N8nInstance> onToggle;
  final ValueChanged<N8nInstance> onDelete;
  final ValueChanged<N8nInstance> onDetails;
  final void Function(String, {bool success}) onMessage;

  @override
  State<N8nPage> createState() => _N8nPageState();
}

class _N8nPageState extends State<N8nPage> {
  String _query = '';
  String _status = 'Todos';

  List<N8nInstance> get filtered {
    return widget.instances.where((instance) {
      final query = _query.toLowerCase();
      final matchesStatus = _status == 'Todos' ||
          (_status == 'Activas' && instance.running) ||
          (_status == 'Detenidas' && !instance.running);

      return (instance.name.toLowerCase().contains(query) ||
              instance.owner.toLowerCase().contains(query)) &&
          matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Servicio de N8N',
            subtitle:
                'Supervisa las instancias de automatización (workflows) '
                'asignadas a cada usuario en el clúster.',
            action: 'Exportar listado',
            actionIcon: Icons.download_rounded,
            onAction: () => widget.onMessage(
              'El listado se está exportando.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar instancia o propietario...',
            selectedFilter: _status,
            filters: const [
              'Todos',
              'Activas',
              'Detenidas',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _status = value),
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.hub_rounded,
              title: 'No encontramos instancias de N8N',
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
                        (instance) => N8nInstanceCard(
                          width: cardWidth,
                          instance: instance,
                          onDetails: () => widget.onDetails(instance),
                          onToggle: () => widget.onToggle(instance),
                          onDelete: () => widget.onDelete(instance),
                          onRestart: () => widget.onMessage(
                            '${instance.name} se está reiniciando.',
                            success: true,
                          ),
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
