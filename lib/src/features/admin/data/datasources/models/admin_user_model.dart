// ==========================================
// Archivo: lib/src/features/admin/data/models/admin_user_model.dart
// Qué hace: Mapea la respuesta JSON de los endpoints /api/users hacia la entidad de dominio PlatformUser.
// Dónde se conecta: Utilizado por AdminUsersRemoteDatasource y AdminUsersNotifier.
// De dónde recibe datos: Deserializa las respuestas JSON del backend ASP.NET Core (UserReadDto).
// ==========================================

import 'package:frontend_landing/src/features/admin/data/models/admin_date_formatter.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart';

/// Modelo de datos que convierte la respuesta JSON de UserReadDto en la entidad limpia PlatformUser.
///
/// Nota: el backend (UserReadDto) NO expone un campo "suspended" explícito. La única forma de
/// desactivar un usuario hoy es el soft-delete (DELETE /api/users/{id}), que llena DeletedAt.
/// Por eso `suspended` se deriva de `deletedAt != null`. Ver AdminUsersNotifier para el detalle
/// de esta limitación al momento de reactivar un usuario.
class AdminUserModel {
  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.lastLogin,
    required this.deletedAt,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final DateTime? deletedAt;

  /// Factory constructor para deserializar el JSON del backend (UserReadDto)
  factory AdminUserModel.fromJson(Map<String, dynamic> json) {
    return AdminUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'User',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      lastLogin: DateTime.tryParse(json['lastLogin']?.toString() ?? ''),
      deletedAt: DateTime.tryParse(json['deletedAt']?.toString() ?? ''),
    );
  }

  /// Convierte el modelo HTTP en la entidad limpia PlatformUser que consume la UI.
  /// [instanceCount] se calcula fuera de este modelo (contando DatabaseInstanceReadDto
  /// por userId), ya que UserReadDto no trae ese dato.
  PlatformUser toEntity({required int instanceCount}) {
    return PlatformUser(
      id: id,
      name: name,
      email: email,
      createdAt: AdminDateFormatter.formatDate(createdAt),
      lastAccess: AdminDateFormatter.formatRelative(lastLogin),
      instances: instanceCount,
      suspended: deletedAt != null,
    );
  }
}
