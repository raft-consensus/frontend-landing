import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_n8n_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_access_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_templates_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_toolbar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/n8n_workflows_list.dart';

/// ¿Qué hace?: Vista principal del servicio de n8n Workflows que ensambla los sub-widgets atómicos y administra el filtro de búsqueda.
/// ¿De dónde trae datos?: Escucha userN8nProvider usando Riverpod y recibe el callback onMessage del Dashboard.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en el IndexedStack de DashboardPage (opción de menú n8n).
class N8nServicesPage extends ConsumerStatefulWidget {
  final void Function(String message, {bool success}) onMessage; // Callback para disparar notificaciones flotantes

  const N8nServicesPage({
    required this.onMessage, // Requerido: Notificador de mensajes SnackBar
    super.key,
  });

  @override
  ConsumerState<N8nServicesPage> createState() => _N8nServicesPageState();
}

class _N8nServicesPageState extends ConsumerState<N8nServicesPage> {
  String _searchQuery = ''; // Variable de estado local para almacenar la cadena tipeada en la búsqueda

  /// Método privado para alternar el estado de un flujo de trabajo (Pausar / Activar)
  void _handleToggleWorkflow(String workflowId) {
    ref.read(userN8nProvider.notifier).toggleWorkflowStatus(workflowId); // Llama al notifier de Riverpod
    widget.onMessage('Estado del flujo actualizado correctamente', success: true); // Muestra notificación
  }

  /// Método privado al seleccionar una plantilla pre-diseñada
  void _handleUseTemplate(String templateName) {
    widget.onMessage('Plantilla "$templateName" lista para importar en n8n Studio', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final n8nData = ref.watch(userN8nProvider); // Escucha el estado reactivo del provider de n8n

    // Estado de carga si los datos del servicio aún no han sido inicializados
    if (n8nData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filtra la lista de flujos en tiempo real según lo tipeado en el campo de búsqueda
    final filteredWorkflows = n8nData.workflows.where((wf) {
      if (_searchQuery.trim().isEmpty) return true; // Si no hay búsqueda, retorna todos los flujos
      final q = _searchQuery.toLowerCase().trim();   // Convierte la búsqueda a minúsculas
      return wf.name.toLowerCase().contains(q) || wf.trigger.toLowerCase().contains(q); // Compara por nombre o trigger
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Encabezado de la Sección
          const SectionHeader(
            title: 'Automatización & Workflows (n8n)', // Título principal
            subtitle: 'Gestiona la integración con la célula de automatización n8n y tus flujos activos', // Subtítulo
          ),
          const SizedBox(height: 20),

          // 2. Tarjetas KPI Superiores (Estado, Flujos Activos, Ejecuciones Mensuales)
          N8nSummaryCards(
            serviceStatus: n8nData.serviceStatus,           // Estado del servicio ("ACTIVE")
            activeWorkflows: n8nData.activeWorkflows,         // Cantidad de flujos activos
            maxWorkflows: n8nData.maxWorkflows,              // Límite de flujos asignados
            monthlyExecutions: n8nData.monthlyExecutions,    // Consumo de ejecuciones
            maxMonthlyExecutions: n8nData.maxMonthlyExecutions, // Límite de ejecuciones
          ),
          const SizedBox(height: 24),

          // 3. Banner CTA de Acceso a n8n Studio y Credenciales
          N8nAccessBanner(
            studioUrl: n8nData.studioUrl,           // URL de acceso a n8n Studio
            apiKey: n8nData.apiKey,                 // API Key del usuario
            webhookBaseUrl: n8nData.webhookBaseUrl, // URL Base de Webhooks
            onMessage: widget.onMessage,            // Callback para mensajes
          ),
          const SizedBox(height: 24),

          // 4. Barra de Herramientas y Búsqueda en Tiempo Real
          N8nToolbar(
            totalWorkflows: filteredWorkflows.length, // Total de flujos encontrados tras filtrar
            onSearchChanged: (text) => setState(() => _searchQuery = text), // Actualiza estado de búsqueda
          ),
          const SizedBox(height: 12),

          // 5. Tabla / Lista de Flujos Filtrados
          N8nWorkflowsList(
            workflows: filteredWorkflows,        // Lista de flujos ya filtrados
            onToggleStatus: _handleToggleWorkflow, // Callback para pausar / activar
            onCopyWebhook: (url) {
              widget.onMessage('URL de Webhook copiada al portapapeles', success: true);
            },
          ),
          const SizedBox(height: 24),

          // 6. Sección de Plantillas Pre-configuradas
          N8nTemplatesSection(
            onUseTemplate: _handleUseTemplate, // Callback al seleccionar plantilla
          ),
          const SizedBox(height: 24),

          // 7. Tarjeta Informativa al Pie
          const N8nInfoCard(),
        ],
      ),
    );
  }
}
