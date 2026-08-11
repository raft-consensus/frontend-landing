// ==========================================
// Qué hace: Entidad de dominio que representa una API Key del Servicio de IA.
// Dónde se conecta: Utilizada en los componentes de presentation/widgets/ai/.
// De dónde recibe datos: Convertida a partir de AiKeyModel desde la API C#.
// ==========================================

/// Entidad pura de dominio para las API Keys de Inteligencia Artificial
class AiKey {
  const AiKey({
    required this.id,                     // ID numérico de la clave en base de datos
    required this.name,                   // Nombre asignado por el usuario (ej: "bot-produccion")
    required this.keyPrefix,              // Prefijo visible públicamente (ej: "pr_ai_LWje9I...")
    required this.status,                 // Estado reportado por C# ("Active", "Revoked")
    required this.createdAt,              // Fecha ISO8601 de creación
    required this.totalRequests,          // Total acumulado de peticiones HTTP
    required this.totalPromptTokens,      // Total acumulado de tokens de prompt (entrada)
    required this.totalCompletionTokens,  // Total acumulado de tokens de respuesta (salida)
    required this.totalTokens,            // Total acumulado de tokens consumidos (entrada + salida)
    required this.approxCostUsd,          // Costo aproximado en dólares USD
    this.lastUsedAt,                      // Timestamp del último uso (puede ser nulo)
  });

  final String id;
  final String name;
  final String keyPrefix;
  final String status;
  final String createdAt;
  final int totalRequests;
  final int totalPromptTokens;
  final int totalCompletionTokens;
  final int totalTokens;
  final double approxCostUsd;
  final String? lastUsedAt;

  /// Retorna si la clave se encuentra en estado activo
  bool get isActive => status.toLowerCase() == 'active';
}
