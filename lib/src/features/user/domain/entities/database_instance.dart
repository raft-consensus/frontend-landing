// ==========================================
// Archivo: lib/src/features/user/domain/entities/database_instance.dart
// Qué hace: Entidad pura de dominio que representa una instancia de Base de Datos del usuario.
// Dónde se conecta: Consumida por los modelos de datos, repositorios, notificadores y widgets de UI.
// De dónde recibe datos: Construida desde DatabaseModel tras deserializar las respuestas del backend.
// ==========================================

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
    this.usedSpaceBytes = 0,       // Almacenamiento ocupado exacto en Bytes (ej: 40960 B)
    this.maxSpaceBytes = 20971520, // Límite máximo asignado en Bytes (ej: 20971520 B = 20 MB)
    this.isRunning = true,          // Estado de ejecución activa/detenida
  });

  final String id;           // Identificador único de la BD (ej. db-001)
  final String name;         // Nombre dado por el usuario (ej. proyecto-universidad)
  final String engine;       // Motor utilizado (PostgreSQL, MySQL, MongoDB, SQL Server)
  final String version;      // Versión activa del motor (ej. 16, 8.0)
  final String database;     // Nombre de la base de datos interna
  final String username;     // Usuario principal de conexión
  final String host;         // URL del servidor asignado (ej. pg01.raftdb.dev)
  final int port;            // Puerto de red para la conexión (ej. 5432)
  final double storageUsed;  // Almacenamiento ocupado actualmente en Megabytes
  final double storageLimit; // Límite máximo de almacenamiento en Megabytes
  final int usedSpaceBytes;  // Cantidad exacta en Bytes ocupada en el servidor
  final int maxSpaceBytes;   // Cantidad máxima asignada en Bytes por el servidor
  final String createdAt;    // Fecha formateada de creación

  bool isRunning;            // Estado de ejecución: true (activa) / false (detenida)
}
