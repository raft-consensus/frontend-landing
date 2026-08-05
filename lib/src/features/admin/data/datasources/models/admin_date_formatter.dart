// ==========================================
// Archivo: lib/src/features/admin/data/models/admin_date_formatter.dart
// Qué hace: Convierte fechas ISO/DateTime del backend a los formatos en español
//           que la UI del panel administrativo espera (ej: '23 Jul 2026', '23 Jul · 10:42', 'Hace 5 min').
// Dónde se conecta: Utilizado por AdminUserModel, ManagedDatabaseModel y AuditEventModel.
// De dónde recibe datos: Fechas ya parseadas desde el JSON del backend ASP.NET Core.
// ==========================================

/// Utilidades de formateo de fecha compartidas por los modelos de datos del panel admin.
/// No se usa el paquete `intl` porque el proyecto no lo tiene como dependencia;
/// se implementa un mapeo manual de meses en español.
class AdminDateFormatter {
  AdminDateFormatter._();

  static const List<String> _months = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  /// Formatea una fecha como '23 Jul 2026'
  static String formatDate(DateTime? date) {
    if (date == null) return '—';
    final local = date.toLocal();
    return '${local.day} ${_months[local.month - 1]} ${local.year}';
  }

  /// Formatea una fecha con hora como '23 Jul · 10:42'
  static String formatDateTime(DateTime? date) {
    if (date == null) return '—';
    final local = date.toLocal();
    final hh = local.hour.toString().padLeft(2, '0');
    final mm = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${_months[local.month - 1]} · $hh:$mm';
  }

  /// Formatea una fecha como tiempo relativo: 'Hace 5 min', 'Ayer', 'Hace 2 días'
  static String formatRelative(DateTime? date) {
    if (date == null) return 'Sin actividad';
    final local = date.toLocal();
    final diff = DateTime.now().difference(local);

    if (diff.inMinutes < 1) return 'Justo ahora';
    if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    if (diff.inDays < 30) return 'Hace ${diff.inDays} días';
    return formatDate(local);
  }
}
