import 'package:frontend_landing/src/features/landing/domain/entities/platform_metrics.dart';

/// Modelo de datos (DTO) para la respuesta de métricas de la plataforma.
/// 
/// ¿Qué hace?: Extiende la entidad de dominio PlatformMetrics y añade la capacidad de ser creado a partir de JSON.
/// ¿De dónde recibe datos?: Mapa JSON (Map<String, dynamic>) proveniente del servidor backend ASP.NET Core.
/// ¿Hacia dónde va / Dónde se conecta?: Se utiliza en MetricsRemoteDataSource para deserializar la respuesta del API.
class PlatformMetricsModel extends PlatformMetrics {
  const PlatformMetricsModel({
    required super.totalUsers,
    required super.totalDatabases,
    required super.activeDatabases,
    required super.totalLogins,
    required super.activeUsers,
    required super.serviceAvailability,
  });

  /// Factory constructor que convierte la respuesta JSON de la API en una instancia de PlatformMetricsModel.
  factory PlatformMetricsModel.fromJson(Map<String, dynamic> json) {
    return PlatformMetricsModel(
      totalUsers: (json['totalUsers'] as num?)?.toInt() ?? 0,
      totalDatabases: (json['totalDatabases'] as num?)?.toInt() ?? 0,
      activeDatabases: (json['activeDatabases'] as num?)?.toInt() ?? 0,
      totalLogins: (json['totalLogins'] as num?)?.toInt() ?? 0,
      activeUsers: (json['activeUsers'] as num?)?.toInt() ?? 0,
      serviceAvailability:
          (json['serviceAvailability'] as num?)?.toDouble() ?? 0.0,
    );
  }

  /// Convierte la instancia actual en un Mapa JSON (útil para pruebas o envío).
  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalDatabases': totalDatabases,
      'activeDatabases': activeDatabases,
      'totalLogins': totalLogins,
      'activeUsers': activeUsers,
      'serviceAvailability': serviceAvailability,
    };
  }
}
