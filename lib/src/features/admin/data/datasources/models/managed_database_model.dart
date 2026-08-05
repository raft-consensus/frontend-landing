// ==========================================
// Archivo: lib/src/features/admin/data/models/managed_database_model.dart
// Qué hace: Mapea la respuesta JSON de /api/database-instances hacia la entidad de dominio ManagedDatabase.
// Dónde se conecta: Utilizado por AdminDatabasesRemoteDatasource y AdminDatabasesNotifier.
// De dónde recibe datos: Deserializa las respuestas JSON del backend ASP.NET Core (DatabaseInstanceReadDto).
// ==========================================

import 'package:frontend_landing/src/features/admin/data/models/admin_date_formatter.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart';

/// Modelo de datos que convierte la respuesta JSON de DatabaseInstanceReadDto en la
/// entidad limpia ManagedDatabase, y conserva los campos "crudos" necesarios para
/// poder reconstruir un PUT completo (el backend exige reenviar TODOS los campos
/// en DatabaseInstanceUpdateDto, no solo el que cambia).
class ManagedDatabaseModel {
  ManagedDatabaseModel({
    required this.id,
    required this.userId,
    required this.host,
    required this.port,
    required this.databaseName,
    required this.databaseUser,
    required this.engine,
    required this.status,
    required this.usedSpaceBytes,
    required this.maxSpaceBytes,
    required this.lastActivity,
    required this.createdAt,
  });

  final int id;
  final int userId;
  final String host;
  final int port;
  final String databaseName;
  final String databaseUser;
  final String engine;
  final String status; // "Active" | "Suspended" | "Deleted"
  final int usedSpaceBytes;
  final int maxSpaceBytes;
  final DateTime? lastActivity;
  final DateTime createdAt;

  /// Factory constructor para deserializar el JSON del backend (DatabaseInstanceReadDto)
  factory ManagedDatabaseModel.fromJson(Map<String, dynamic> json) {
    return ManagedDatabaseModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      host: json['host'] ?? '',
      port: json['port'] ?? 0,
      databaseName: json['databaseName'] ?? '',
      databaseUser: json['databaseUser'] ?? '',
      engine: json['engine'] ?? 'MySQL',
      status: json['status'] ?? 'Active',
      usedSpaceBytes: json['usedSpaceBytes'] ?? 0,
      maxSpaceBytes: json['maxSpaceBytes'] ?? 0,
      lastActivity: DateTime.tryParse(json['lastActivity']?.toString() ?? ''),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Convierte el modelo HTTP en la entidad limpia ManagedDatabase que consume la UI.
  /// [ownerName] se resuelve fuera de este modelo (cruzando el userId contra la
  /// lista de usuarios), ya que DatabaseInstanceReadDto solo trae el userId.
  ManagedDatabase toEntity({required String ownerName}) {
    final storageMb = usedSpaceBytes / (1024 * 1024);

    return ManagedDatabase(
      id: id,
      name: databaseName,
      owner: ownerName,
      engine: engine,
      host: host,
      storageMb: storageMb,
      createdAt: AdminDateFormatter.formatDate(createdAt),
      running: status.toLowerCase() == 'active',
    );
  }

  /// Reconstruye el cuerpo completo que exige PUT /api/database-instances/{id},
  /// cambiando únicamente el [newStatus] indicado y reenviando el resto de campos
  /// tal como se conocían en el último fetch.
  Map<String, dynamic> toUpdateJson({required String newStatus}) {
    return {
      'userId': userId,
      'host': host,
      'port': port,
      'databaseName': databaseName,
      'databaseUser': databaseUser,
      'engine': engine,
      'status': newStatus,
      'usedSpaceBytes': usedSpaceBytes,
      'maxSpaceBytes': maxSpaceBytes,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }
}
