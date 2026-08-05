// ==========================================
// Archivo: lib/src/features/admin/data/models/platform_metrics_model.dart
// Qué hace: Mapea la respuesta JSON de GET /api/metrics/platform con los indicadores globales
//           de la plataforma (usuarios totales, instancias, disponibilidad, etc.).
// Dónde se conecta: Utilizado por PlatformMetricsRemoteDatasource y AdminMetricsNotifier,
//           consumido por AdminOverviewPage a través de AdminDashboard.
// De dónde recibe datos: Deserializa la respuesta JSON del backend ASP.NET Core (PlatformMetricsDto).
// ==========================================

/// Modelo de datos con las métricas globales expuestas por el backend.
///
/// Nota: este endpoint (api/metrics/platform) es público (no requiere rol Admin),
/// pero se sigue enviando el token si existe por consistencia con el resto del panel.
/// No existe una entidad de dominio dedicada para estas métricas: al ser un simple
/// paquete de contadores de solo lectura, se consume directamente desde este modelo.
class PlatformMetricsModel {
  PlatformMetricsModel({
    required this.totalUsers,
    required this.totalDatabases,
    required this.activeDatabases,
    required this.totalLogins,
    required this.activeUsers,
    required this.serviceAvailability,
  });

  final int totalUsers;
  final int totalDatabases;
  final int activeDatabases;
  final int totalLogins;
  final int activeUsers;
  final double serviceAvailability;

  /// Instancia "vacía" usada mientras se carga la primera respuesta del backend.
  factory PlatformMetricsModel.empty() {
    return PlatformMetricsModel(
      totalUsers: 0,
      totalDatabases: 0,
      activeDatabases: 0,
      totalLogins: 0,
      activeUsers: 0,
      serviceAvailability: 0,
    );
  }

  /// Factory constructor para deserializar el JSON del backend (PlatformMetricsDto)
  factory PlatformMetricsModel.fromJson(Map<String, dynamic> json) {
    return PlatformMetricsModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalDatabases: json['totalDatabases'] ?? 0,
      activeDatabases: json['activeDatabases'] ?? 0,
      totalLogins: json['totalLogins'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      serviceAvailability:
          (json['serviceAvailability'] as num?)?.toDouble() ?? 0,
    );
  }
}
