/// Entidad pura de dominio que representa una instancia de Base de Datos del usuario.
class DatabaseInstance {
  DatabaseInstance({
    required this.id,
    required this.name,
    required this.engine,
    required this.version,
    required this.database,
    required this.username,
    required this.host,
    required this.port,
    required this.storageUsed,
    required this.storageLimit,
    required this.createdAt,
    this.isRunning = true, // Por defecto inicia encendida (estado mutable)
  });

  final String id;           // Identificador único de la BD (ej. db-001)
  final String name;         // Nombre dado por el usuario (ej. proyecto-universidad)
  final String engine;       // Motor utilizado (PostgreSQL, MySQL, MongoDB, SQL Server)
  final String version;      // Versión activa del motor (ej. 16, 8.0)
  final String database;     // Nombre de la base de datos interna
  final String username;     // Usuario principal de conexión
  final String host;         // URL del servidor asignado (ej. pg01.raftdb.dev)
  final int port;            // Puerto de red para la conexión (ej. 5432)
  final double storageUsed;  // Almacenamiento ocupado actualmente en MB
  final double storageLimit; // Límite máximo de almacenamiento en MB
  final String createdAt;    // Fecha formateada de creación

  bool isRunning;            // Estado de ejecución: true (activa) / false (detenida)
}
