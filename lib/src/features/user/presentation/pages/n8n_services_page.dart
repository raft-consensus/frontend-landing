// ==========================================
// Que hace: Vista principal del servicio de n8n Workflows sin encabezados redundantes.
// De donde trae datos: Escucha userN8nProvider usando Riverpod.
// Donde se conecta: Renderizado en el indice 4 del IndexedStack en DashboardPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_n8n_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/banner/n8n_access_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/info/n8n_info_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/summary/n8n_summary_cards.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/templates/n8n_templates_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/workflows/n8n_toolbar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/n8n/workflows/n8n_workflows_list.dart';

/// Vista principal del servicio de n8n Workflows
class N8nServicesPage extends ConsumerStatefulWidget {
  final void Function(String message, {bool success}) onMessage; // Callback para notificaciones en SnackBar

  const N8nServicesPage({
    required this.onMessage,
    super.key,
  });

  @override
  ConsumerState<N8nServicesPage> createState() => _N8nServicesPageState();
}

class _N8nServicesPageState extends ConsumerState<N8nServicesPage> {
  String _searchQuery = ''; // Busqueda de flujos en tiempo real

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userN8nProvider.notifier).loadN8nData();
    });
  }

  void _handleToggleWorkflow(String workflowId) {
    ref.read(userN8nProvider.notifier).toggleWorkflowStatus(workflowId);
    widget.onMessage('Estado del flujo actualizado correctamente', success: true);
  }

  Future<void> _handleProvisionAccount() async {
    final success = await ref.read(userN8nProvider.notifier).provisionAccount();
    if (success) {
      widget.onMessage('Cuenta de n8n activada correctamente', success: true);
    } else {
      widget.onMessage('Error al activar la cuenta de n8n', success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final n8nData = ref.watch(userN8nProvider);

    if (n8nData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredWorkflows = n8nData.workflows.where((wf) {
      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase().trim();
      return wf.name.toLowerCase().contains(q) || wf.trigger.toLowerCase().contains(q);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tarjetas KPI Adaptativas directas
          N8nSummaryCards(
            isActivated: n8nData.isActivated,
            serviceStatus: n8nData.serviceStatus,
            activeWorkflows: n8nData.activeWorkflows,
            maxWorkflows: n8nData.maxWorkflows,
            monthlyExecutions: n8nData.monthlyExecutions,
            maxMonthlyExecutions: n8nData.maxMonthlyExecutions,
          ),
          const SizedBox(height: 24),

          // 2. Banner Principal de Acceso y Activacion
          N8nAccessBanner(
            isActivated: n8nData.isActivated,
            studioUrl: n8nData.studioUrl,
            apiKey: n8nData.apiKey,
            webhookBaseUrl: n8nData.webhookBaseUrl,
            onProvision: _handleProvisionAccount,
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // 3. Barra de busqueda y herramientas
          N8nToolbar(
            totalWorkflows: filteredWorkflows.length,
            onSearchChanged: (text) => setState(() => _searchQuery = text),
          ),
          const SizedBox(height: 12),

          // 4. Lista de Flujos
          N8nWorkflowsList(
            workflows: filteredWorkflows,
            onToggleStatus: _handleToggleWorkflow,
            onCopyWebhook: (url) {
              widget.onMessage('URL de Webhook copiada al portapapeles', success: true);
            },
          ),
          const SizedBox(height: 24),

          // 5. Seccion de Plantillas Recomendadas
          N8nTemplatesSection(
            onMessage: widget.onMessage,
          ),
          const SizedBox(height: 24),

          // 6. Tarjeta Informativa al Pie
          const N8nInfoCard(),
        ],
      ),
    );
  }
}
