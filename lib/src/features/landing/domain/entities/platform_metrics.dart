/// Entidad de dominio que representa las métricas globales de la plataforma.
/// 
/// ¿Qué hace?: Almacena los datos puros de negocio sobre el estado y estadísticas de Raft DB.
/// ¿De dónde recibe datos?: Se mapea a partir del DTO PlatformMetricsModel en la capa de datos.
/// ¿Hacia dónde va / Dónde se conecta?: Se consume en la capa de presentación mediante platformMetricsProvider.
class PlatformMetrics {
  const PlatformMetrics({
    required this.totalUsers, // Total de usuarios registrados
    required this.totalDatabases, // Total de BDs aprovisionadas
    required this.activeDatabases, // BDs activas en el clúster
    required this.totalSubdomains, // Subdominios DNS activos
    required this.totalAiRequests, // Consultas IA generadas
    required this.totalN8nExecutions, // Flujos n8n ejecutados
    required this.totalSecureOperations, // Conteo de eventos y operaciones de auditoría
    required this.totalLogins, // Inicios de sesión registrados
    required this.activeUsers, // Usuarios con actividad reciente
    required this.serviceAvailability, // Porcentaje de disponibilidad histórica
  });

  /// Total de usuarios registrados en el sistema
  final int totalUsers;

  /// Total de bases de datos aprovisionadas
  final int totalDatabases;

  /// Total de bases de datos actualmente en estado 'Active'
  final int activeDatabases;

  /// Total de registros y subdominios DNS activos
  final int totalSubdomains;

  /// Total de consultas o peticiones de IA procesadas
  final int totalAiRequests;

  /// Total de ejecuciones de flujos de trabajo n8n
  final int totalN8nExecutions;

  /// Total de operaciones seguras registradas en auditoría
  final int totalSecureOperations;

  /// Cantidad total de inicios de sesión efectuados
  final int totalLogins;

  /// Cantidad de usuarios activos en la plataforma
  final int activeUsers;

  /// Porcentaje de disponibilidad del servicio
  final double serviceAvailability;
}
