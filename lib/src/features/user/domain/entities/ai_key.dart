/// ¿Qué hace?: Entidad de dominio pura que representa una API Key del servicio de IA y su consumo asignado.
/// ¿De dónde trae datos?: Recibe información procesada desde el backend REST de Raft DB / Célula de IA.
/// ¿Hacia dónde va / Cómo se conecta?: Consumida por UserAiNotifier en la capa de presentación y renderizada en AiServicesPage.
class AiKey {
  AiKey({
    required this.id,
    required this.name,
    required this.apiKey,
    required this.createdAt,
    required this.requestsUsed,
    required this.requestsLimit,
    this.status = 'active',
  });

  final String id; // Identificador único de la clave
  final String name; // Nombre o etiqueta descriptiva (ej. "App Producción")
  final String apiKey; // Token de autenticación de la API Key (ej. "raft_ai_9k8a7f...")
  final String createdAt; // Fecha de generación
  final int requestsUsed; // Solicitudes consumidas
  final int requestsLimit; // Límite máximo de solicitudes permitidas
  final String status; // Estado (ej. "active", "revoked")

  /// Porcentaje de consumo (0.0 a 1.0)
  double get usagePercentage {
    if (requestsLimit <= 0) return 0.0;
    return (requestsUsed / requestsLimit).clamp(0.0, 1.0);
  }

  /// Retorna versión enmascarada del token (ej. "raft_ai_...7f90")
  String get maskedKey {
    if (apiKey.length <= 12) return '••••••••••••';
    return '${apiKey.substring(0, 8)}...${apiKey.substring(apiKey.length - 4)}';
  }

  /// Copia inmutable
  AiKey copyWith({
    String? id,
    String? name,
    String? apiKey,
    String? createdAt,
    int? requestsUsed,
    int? requestsLimit,
    String? status,
  }) {
    return AiKey(
      id: id ?? this.id,
      name: name ?? this.name,
      apiKey: apiKey ?? this.apiKey,
      createdAt: createdAt ?? this.createdAt,
      requestsUsed: requestsUsed ?? this.requestsUsed,
      requestsLimit: requestsLimit ?? this.requestsLimit,
      status: status ?? this.status,
    );
  }
}
