import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_service_data.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_workflow.dart';

/// ¿Qué hace?: Gestor de estado reactivo que controla la metadata del servicio n8n y la lista de flujos.
/// ¿De dónde trae datos?: Inicia con un estado de datos simulados (mock) estructurado para pruebas en UI.
/// ¿Hacia dónde va / Cómo se conecta?: Se expone como userN8nProvider para ser consumido en N8nServicesPage y sus sub-widgets.
class UserN8nNotifier extends StateNotifier<N8nServiceData?> {
  UserN8nNotifier() : super(_initialMockState); // Inicializa el estado con los datos simulados por defecto

  /// Datos iniciales de prueba (Mock) que simulan la respuesta enviada por el proxy de n8n
  static final N8nServiceData _initialMockState = N8nServiceData(
    serviceStatus: 'ACTIVE',                                // Estado activo de la conexión
    studioUrl: 'https://n8n.raft.andrescortes.dev',        // URL de la instancia n8n Studio
    apiKey: 'n8n_usr_live_8912f7a3b40',                    // API Key de prueba
    webhookBaseUrl: 'https://n8n.raft.andrescortes.dev/webhook/raft-db/', // Endpoint base
    activeWorkflows: 2,                                    // 2 flujos activos actualmente
    maxWorkflows: 5,                                       // Límite de 5 flujos permitidos
    monthlyExecutions: 428,                                // 428 ejecuciones consumidas este mes
    maxMonthlyExecutions: 1000,                            // Límite de 1,000 ejecuciones al mes
    workflows: [
      N8nWorkflow(
        id: 'wf-01',                                       // ID del primer flujo
        name: 'Notificación de Backup en Discord',         // Nombre descriptivo
        trigger: 'Evento Backup Raft DB',                   // Evento que lo dispara
        isActive: true,                                    // Flujo en estado activo
        lastExecutedAt: DateTime.now().subtract(const Duration(minutes: 45)), // Ejecutado hace 45 min
        executionCount: 184,                               // 184 ejecuciones acumuladas
      ),
      N8nWorkflow(
        id: 'wf-02',                                       // ID del segundo flujo
        name: 'Alerta de Consumo Alto de CPU',             // Nombre descriptivo
        trigger: 'Webhook de Métrica',                     // Evento que lo dispara
        isActive: true,                                    // Flujo en estado activo
        lastExecutedAt: DateTime.now().subtract(const Duration(hours: 3)), // Ejecutado hace 3 horas
        executionCount: 210,                               // 210 ejecuciones acumuladas
      ),
      N8nWorkflow(
        id: 'wf-03',                                       // ID del tercer flujo
        name: 'Exportación Diaria a Google Sheets',        // Nombre descriptivo
        trigger: 'Cron Programado (00:00 UTC)',            // Disparador por tiempo
        isActive: false,                                   // Flujo pausado por el usuario
        lastExecutedAt: DateTime.now().subtract(const Duration(days: 1)), // Ejecutado ayer
        executionCount: 34,                                // 34 ejecuciones acumuladas
      ),
    ],
  );

  /// Función para regenerar la clave de API del usuario
  Future<String?> regenerateApiKey() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simula latencia de red

    if (state != null) {
      // Genera una nueva cadena aleatoria simulada
      final newKey = 'n8n_usr_live_${DateTime.now().millisecondsSinceEpoch}';
      
      // Actualiza el estado inmutablemente con la nueva clave de API
      state = state!.copyWith(apiKey: newKey);
    }
    return null; // Retorna null indicando que no hubo error
  }

  /// Función para alternar el estado activo / pausado de un flujo específico
  void toggleWorkflowStatus(String workflowId) {
    if (state == null) return; // Si no hay datos cargados, no realiza acción

    // Mapea la lista actual actualizando el flujo que coincide con el ID
    final updatedList = state!.workflows.map((wf) {
      if (wf.id == workflowId) {
        return wf.copyWith(isActive: !wf.isActive); // Invierte el estado booleano
      }
      return wf; // Deja los demás flujos sin cambios
    }).toList();

    // Recalcula el total de flujos activos
    final newActiveCount = updatedList.where((w) => w.isActive).length;

    // Actualiza el estado global inmutablemente
    state = state!.copyWith(
      workflows: updatedList,
      activeWorkflows: newActiveCount,
    );
  }
}

/// Provider global accesible en toda la aplicación Flutter a través de Riverpod
final userN8nProvider = StateNotifierProvider<UserN8nNotifier, N8nServiceData?>((ref) {
  return UserN8nNotifier(); // Retorna la instancia única del Notifier
});
