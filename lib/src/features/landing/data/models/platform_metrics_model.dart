import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';

/// Modelo de datos (DTO) para la respuesta de métricas de la plataforma.
/// 
/// ¿Qué hace?: Extiende la entidad de dominio PlatformMetrics y añade serialización JSON.
/// ¿De dónde recibe datos?: Mapa JSON (Map<String, dynamic>) proveniente del endpoint '/api/metrics/platform'.
/// ¿Hacia dónde va / Dónde se conecta?: Se utiliza en MetricsRemoteDataSource para deserializar la respuesta del API.
class PlatformMetricsModel extends PlatformMetrics {
  const PlatformMetricsModel({
    required super.totalUsers, // Inyección a superclase
    required super.totalDatabases, // Inyección a superclase
    required super.activeDatabases, // Inyección a superclase
    required super.totalSubdomains, // Inyección a superclase
    required super.totalAiRequests, // Inyección a superclase
    required super.totalN8nExecutions, // Inyección a superclase
    required super.totalSecureOperations, // Inyección a superclase
    required super.totalLogins, // Inyección a superclase
    required super.activeUsers, // Inyección a superclase
    required super.serviceAvailability, // Inyección a superclase
  });

  /// Factory constructor que convierte la respuesta JSON de la API en una instancia de PlatformMetricsModel.
  factory PlatformMetricsModel.fromJson(Map<String, dynamic> json) {
    return PlatformMetricsModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0, // Mapeo usuarios
      totalDatabases: (json['totalDatabases'] as num?)?.toInt() ?? 0, // Mapeo BDs totales
      activeDatabases: (json['activeDatabases'] as num?)?.toInt() ?? 0, // Mapeo BDs activas
      totalSubdomains: (json['totalSubdomains'] as num?)?.toInt() ?? 0, // Mapeo subdominios DNS
      totalAiRequests: (json['totalAiRequests'] as num?)?.toInt() ?? 0, // Mapeo peticiones IA
      totalN8nExecutions: (json['totalN8nExecutions'] as num?)?.toInt() ?? 0, // Mapeo flujos n8n
      totalSecureOperations: (json['totalSecureOperations'] as num?)?.toInt() ?? 0, // Mapeo auditoría
      totalLogins: (json['totalLogins'] as num?)?.toInt() ?? 0, // Mapeo logins
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0, // Mapeo usuarios activos
      serviceAvailability:
          (json['serviceAvailability'] as num?)?.toDouble() ?? 0.0, // Mapeo disponibilidad
    );
  }

  /// Convierte la instancia actual en un Mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalDatabases': totalDatabases,
      'activeDatabases': activeDatabases,
      'totalSubdomains': totalSubdomains,
      'totalAiRequests': totalAiRequests,
      'totalN8nExecutions': totalN8nExecutions,
      'totalSecureOperations': totalSecureOperations,
      'totalLogins': totalLogins,
      'activeUsers': activeUsers,
      'serviceAvailability': serviceAvailability,
    };
  }
}
