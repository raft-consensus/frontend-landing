class AuditEvent {
  const AuditEvent({
    required this.action,
    required this.actor,
    required this.resource,
    required this.ip,
    required this.date,
    required this.level,
  });

  final String action;
  final String actor;
  final String resource;
  final String ip;
  final String date;
  final AuditLevel level;
}

enum AuditLevel { info, warning, critical }