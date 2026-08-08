import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_workflow.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_workflow_row_item.dart';

/// ¿Qué hace?: Tarjeta contenedora que renderiza la lista de flujos de n8n o un estado vacío si no hay coincidencias.
/// ¿De dónde trae datos?: Ingesta la lista de flujos filtrada de N8nWorkflow.
/// ¿Hacia dónde va / Cómo se conecta?: Se posiciona en la zona central de N8nServicesPage.
class N8nWorkflowsList extends StatelessWidget {
  final List<N8nWorkflow> workflows;                       // Lista de flujos a renderizar
  final void Function(String id) onToggleStatus;            // Callback para pausar/activar flujo por ID
  final void Function(String webhookUrl) onCopyWebhook;     // Callback para copiar el webhook

  const N8nWorkflowsList({
    required this.workflows,
    required this.onToggleStatus,
    required this.onCopyWebhook,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema activo

    // Si la lista está vacía (por filtro de búsqueda), muestra el estado vacío
    if (workflows.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: const Column(
          children: [
            Icon(Icons.search_off_rounded, size: 40, color: Colors.grey),
            SizedBox(height: 8),
            Text('No se encontraron flujos de trabajo', style: TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      );
    }

    // Renderiza la lista con separadores entre filas
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // Color de tarjeta según tema
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(color: theme.dividerColor), // Borde perimetral
      ),
      child: ListView.separated(
        shrinkWrap: true, // Se adapta a la altura del contenido
        physics: const NeverScrollableScrollPhysics(), // Evita scroll interno ya que la página completa tiene scroll
        itemCount: workflows.length, // Total de ítems
        separatorBuilder: (_, __) => Divider(height: 1, color: theme.dividerColor), // Línea separadora
        itemBuilder: (context, index) {
          final wf = workflows[index]; // Obtiene el flujo correspondiente
          return N8nWorkflowRowItem(
            workflow: wf,
            onToggleStatus: () => onToggleStatus(wf.id), // Dispara la alternancia de estado por ID
            onCopyWebhook: () => onCopyWebhook('https://n8n.raft.andrescortes.dev/webhook/${wf.id}'), // Pasa la URL
          );
        },
      ),
    );
  }
}
