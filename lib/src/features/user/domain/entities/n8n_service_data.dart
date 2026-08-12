import 'package:flutter/foundation.dart';
import 'package:frontend_landing/src/features/user/domain/entities/n8n_workflow.dart';

/// ¿Qué hace?: Entidad de dominio contenedora que agrupa el estado de activación, métricas globales y credenciales del servicio n8n del usuario.
/// ¿De dónde trae datos?: Inmutable, instanciada a partir de las respuestas JSON recibidas del backend (.NET Core API).
/// ¿Hacia dónde va / Cómo se conecta?: Mantenida por UserN8nNotifier y leída por los widgets de presentación en N8nServicesPage.
@immutable
class N8nServiceData {
  final bool isActivated;          // Booleano que indica si la cuenta ya ha sido aprovisionada en el backend SQL Server
  final String? accountId;         // Identificador único de la cuenta de n8n retornado por el backend
  final String serviceStatus;      // Estado de conexión del servicio ("ACTIVE", "PENDING", "INACTIVE")
  final String studioUrl;          // Enlace web directo o credentialUrl para ingresar al entorno n8n Studio
  final String apiKey;             // Clave de API personal o token asignado al usuario
  final String webhookBaseUrl;     // URL base de webhooks para enviar eventos desde Raft DB hacia n8n
  final int activeWorkflows;       // Cantidad actual de flujos que el usuario tiene en estado activo
  final int maxWorkflows;          // Cuota máxima de flujos activos permitidos por el plan
  final int monthlyExecutions;     // Consumo total de ejecuciones durante el mes en curso
  final int maxMonthlyExecutions;  // Límite máximo mensual de ejecuciones permitidas
  final List<N8nWorkflow> workflows; // Lista completa con los flujos monitoreados del usuario

  const N8nServiceData({
    required this.isActivated,          // Requerido: Estado de activación de la cuenta
    this.accountId,                     // Opcional: ID de la cuenta en backend n8n
    required this.serviceStatus,        // Requerido: Estado del servicio
    required this.studioUrl,            // Requerido: Enlace de acceso a n8n Studio
    required this.apiKey,               // Requerido: Clave de API / Token
    required this.webhookBaseUrl,       // Requerido: URL base de Webhooks
    required this.activeWorkflows,      // Requerido: Flujos activos actuales
    required this.maxWorkflows,         // Requerido: Límite máximo de flujos
    required this.monthlyExecutions,    // Requerido: Ejecuciones mes actual
    required this.maxMonthlyExecutions, // Requerido: Límite mensual de ejecuciones
    required this.workflows,            // Requerido: Lista de flujos monitoreados
  });

  /// Método para generar una copia inmutable del objeto con atributos actualizados
  N8nServiceData copyWith({
    bool? isActivated,               // Nuevo estado de activación opcional
    String? accountId,               // Nuevo ID de cuenta opcional
    String? serviceStatus,           // Nuevo estado del servicio opcional
    String? studioUrl,               // Nueva URL de studio opcional
    String? apiKey,                  // Nueva clave de API opcional
    String? webhookBaseUrl,          // Nueva URL base de webhook opcional
    int? activeWorkflows,            // Nuevo recuento de flujos activos opcional
    int? maxWorkflows,               // Nuevo límite de flujos opcional
    int? monthlyExecutions,          // Nuevo contador de ejecuciones opcional
    int? maxMonthlyExecutions,       // Nuevo límite mensual opcional
    List<N8nWorkflow>? workflows,    // Nueva lista de flujos opcional
  }) {
    return N8nServiceData(
      isActivated: isActivated ?? this.isActivated,                   // Mantiene activación previa si es nulo
      accountId: accountId ?? this.accountId,                         // Mantiene ID previo si es nulo
      serviceStatus: serviceStatus ?? this.serviceStatus,             // Mantiene valor previo si es nulo
      studioUrl: studioUrl ?? this.studioUrl,                         // Mantiene URL previa si es nulo
      apiKey: apiKey ?? this.apiKey,                                 // Mantiene la API Key previa si es nulo
      webhookBaseUrl: webhookBaseUrl ?? this.webhookBaseUrl,         // Mantiene URL de webhook previa si es nulo
      activeWorkflows: activeWorkflows ?? this.activeWorkflows,       // Mantiene conteo si es nulo
      maxWorkflows: maxWorkflows ?? this.maxWorkflows,               // Mantiene máximo si es nulo
      monthlyExecutions: monthlyExecutions ?? this.monthlyExecutions, // Mantiene ejecuciones si es nulo
      maxMonthlyExecutions: maxMonthlyExecutions ?? this.maxMonthlyExecutions, // Mantiene límite
      workflows: workflows ?? this.workflows,                         // Mantiene lista previa si es nulo
    );
  }
}
