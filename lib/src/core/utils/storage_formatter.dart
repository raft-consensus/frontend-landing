// ==========================================
// Archivo: lib/src/core/utils/storage_formatter.dart
// Qué hace: Formatea almacenamiento en bytes o megabytes a cadenas de texto legibles con unidades dinámicas (B, KB, MB, GB).
// Dónde se conecta: Consumido por DatabaseModel, DatabaseSummaryCard, DatabaseManagementCard y tarjetas del Dashboard.
// De dónde recibe datos: Recibe enteros (bytes) o decimales (megabytes) desde las entidades de la aplicación.
// ==========================================

/// Utilidad centralizada para dar formato legible a los valores de almacenamiento y consumo de disco.
abstract class StorageFormatter {
  /// ¿Qué hace?: Formatea una cantidad en bytes a una cadena legible con su unidad correspondiente (B, KB, MB, GB).
  /// ¿De dónde recibe datos?: Recibe un entero representando la cantidad total de bytes.
  /// ¿Hacia dónde va / Cómo se conecta?: Retorna un String con la unidad calculada (ejemplo: "512 B", "40.0 KB", "12.5 MB", "1.25 GB").
  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B'; // Muestra en Bytes cuando es inferior a 1 KB
    } else if (bytes < 1024 * 1024) {
      final kb = bytes / 1024; // Convierte a Kilobytes
      return '${kb.toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      final mb = bytes / (1024 * 1024); // Convierte a Megabytes
      return '${mb.toStringAsFixed(1)} MB';
    } else {
      final gb = bytes / (1024 * 1024 * 1024); // Convierte a Gigabytes
      return '${gb.toStringAsFixed(2)} GB';
    }
  }

  /// ¿Qué hace?: Formatea un valor numérico expresado originalmente en Megabytes (double).
  /// ¿De dónde recibe datos?: Recibe un valor de tipo double en Megabytes.
  /// ¿Hacia dónde va / Cómo se conecta?: Reutiliza formatBytes convirtiendo los MB a bytes de origen.
  static String formatMegabytes(double megabytes) {
    final bytes = (megabytes * 1024 * 1024).round(); // Convierte Megabytes a Bytes aproximados
    return formatBytes(bytes);
  }
}
