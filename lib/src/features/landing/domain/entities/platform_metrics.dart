/// Entidad de dominio que representa las métricas globales de la plataforma.
/// 
/// ¿Qué hace?: Almacena los datos puros de negocio sobre el estado y estadísticas de Raft DB.
/// ¿De dónde recibe datos?: Se mapea a partir del DTO PlatformMetricsModel en la capa de datos.
/// ¿Hacia dónde va / Dónde se conecta?: Se consume en la capa de presentación mediante el provider de Riverpod.
class PlatformMetrics {
  const PlatformMetrics({
    required this.totalUsers,
    required this.totalDatabases,
    required this.activeDatabases,
    required this.totalLogins,
    required this.activeUsers,
    required this.serviceAvailability,
  });

  /// Total de usuarios registrados en el sistema
  final int totalUsers;

  /// Total de bases de datos aprovisionadas
  final int totalDatabases;

  /// Total de bases de datos actualmente en estado 'Active'
  final int activeDatabases;

  /// Cantidad total de inicios de sesión efectuados
  final int totalLogins;

  /// Cantidad de usuarios activos en la plataforma
  final int activeUsers;

  /// Porcentaje de disponibilidad del servicio (ej: 100.0)
  final double serviceAvailability;
}
