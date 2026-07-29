// ==========================================
// Archivo: lib/src/features/user/data/models/database_model.dart
// Qué hace: Mapea la respuesta JSON de los endpoints /api/me/databases hacia objetos de la aplicación.
// Dónde se conecta: Utilizado por DatabasesRemoteDatasource y UserDatabasesNotifier.
// De dónde recibe datos: Deserializa las respuestas JSON del backend ASP.NET Core.
// ==========================================

import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';

/// Modelo de datos que convierte la respuesta JSON de la API en la entidad de dominio DatabaseInstance
class DatabaseModel {
  final int databaseInstanceId;
  final String host;
  final int port;
  final String databaseName;
  final String databaseUser;
  final String engine;
  final String status;
  final int usedSpaceBytes;
  final int maxSpaceBytes;
  final String createdAt;

  DatabaseModel({
    required this.databaseInstanceId,
    required this.host,
    required this.port,
    required this.databaseName,
    required this.databaseUser,
    required this.engine,
    required this.status,
    required this.usedSpaceBytes,
    required this.maxSpaceBytes,
    required this.createdAt,
  });

  /// Factory constructor para deserializar el JSON del backend
  factory DatabaseModel.fromJson(Map<String, dynamic> json) {
    return DatabaseModel(
      databaseInstanceId: json['databaseInstanceId'] ?? 0,
      host: json['host'] ?? 'localhost',
      port: json['port'] ?? 3306,
      databaseName: json['databaseName'] ?? '',
      databaseUser: json['databaseUser'] ?? '',
      engine: json['engine'] ?? 'MySQL',
      status: json['status'] ?? 'Active',
      usedSpaceBytes: json['usedSpaceBytes'] ?? 0,
      maxSpaceBytes: json['maxSpaceBytes'] ?? 524288000, // 512 MB por defecto
      createdAt: json['createdAt'] ?? '',
    );
  }

  /// Convierte el modelo de datos HTTP en la entidad limpia DatabaseInstance que consume la UI
  DatabaseInstance toEntity() {
    // Convierte bytes a Megabytes para la representación visual en la UI
    final usedMB = (usedSpaceBytes / (1024 * 1024)).toStringAsFixed(1);
    final limitMB = (maxSpaceBytes / (1024 * 1024)).toStringAsFixed(0);

    return DatabaseInstance(
      id: databaseInstanceId.toString(),
      name: databaseName,
      engine: engine,
      version: _getDefaultVersion(engine),
      database: databaseName,
      username: databaseUser,
      host: host,
      port: port,
      storageUsed: double.tryParse(usedMB) ?? 0.0,
      storageLimit: double.tryParse(limitMB) ?? 512.0,
      createdAt: createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt,
      isRunning: status.toLowerCase() == 'active',
    );
  }

  /// Devuelve la versión por defecto según el motor recibido
  static String _getDefaultVersion(String engineName) {
    switch (engineName.toLowerCase()) {
      case 'postgresql':
        return '16';
      case 'mysql':
        return '8.0';
      case 'sql server':
      case 'sqlserver':
        return '2022';
      case 'mongodb':
        return '7.0';
      default:
        return '1.0';
    }
  }
}
