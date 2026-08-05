// ==========================================
// Archivo: lib/src/features/admin/data/models/audit_event_model.dart
// Qué hace: Mapea la respuesta JSON de /api/audit-events hacia la entidad de dominio AuditEvent.
// Dónde se conecta: Utilizado por AuditEventsRemoteDatasource y AdminAuditNotifier.
// De dónde recibe datos: Deserializa las respuestas JSON del backend ASP.NET Core (AuditEventReadDto).
// ==========================================

import 'package:frontend_landing/src/features/admin/data/models/admin_date_formatter.dart';
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart';

/// Modelo de datos que convierte la respuesta JSON de AuditEventReadDto en la entidad
/// limpia AuditEvent.
///
/// Nota: el backend NO expone un nivel de severidad (AuditLevel). Se deriva con una
/// heurística simple sobre el texto de EventType/Description (ver [_inferLevel]).
/// Si el backend llega a agregar un campo de severidad real, reemplazar esta heurística.
class AuditEventModel {
  AuditEventModel({
    required this.id,
    required this.userId,
    required this.eventType,
    required this.description,
    required this.ipAddress,
    required this.createdAt,
  });

  final int id;
  final int? userId;
  final String eventType;
  final String description;
  final String? ipAddress;
  final DateTime createdAt;

  /// Factory constructor para deserializar el JSON del backend (AuditEventReadDto)
  factory AuditEventModel.fromJson(Map<String, dynamic> json) {
    return AuditEventModel(
      id: json['id'] ?? 0,
      userId: json['userId'],
      eventType: json['eventType'] ?? '',
      description: json['description'] ?? '',
      ipAddress: json['ipAddress'],
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  /// Convierte el modelo HTTP en la entidad limpia AuditEvent que consume la UI.
  /// [actorLabel] se resuelve fuera de este modelo (cruzando el userId contra la
  /// lista de usuarios: email si existe, o 'Sistema' si el evento no tiene userId).
  AuditEvent toEntity({required String actorLabel}) {
    return AuditEvent(
      id: id,
      action: eventType,
      actor: actorLabel,
      resource: description,
      ip: ipAddress ?? '—',
      date: AdminDateFormatter.formatDateTime(createdAt),
      level: _inferLevel(eventType, description),
    );
  }

  /// Heurística de severidad basada en palabras clave del tipo/descripción del evento,
  /// ya que el backend no persiste un nivel explícito.
  static AuditLevel _inferLevel(String eventType, String description) {
    final text = '$eventType $description'.toLowerCase();

    const criticalKeywords = ['failed', 'fail', 'denied', 'error', 'critical'];
    const warningKeywords = ['suspend', 'delete', 'warning', 'stopped'];

    if (criticalKeywords.any(text.contains)) return AuditLevel.critical;
    if (warningKeywords.any(text.contains)) return AuditLevel.warning;
    return AuditLevel.info;
  }
}
