import 'package:flutter/material.dart';

/// Utility estático para la conversión y selección de fechas de nacimiento.
/// 
/// ¿Qué hace?: Formatea fechas ISO <-> Texto de pantalla (AAAA-MM-DD) y despliega el DatePicker modal.
/// ¿De dónde recibe datos?: Cadenas de texto de fecha y BuildContext.
/// ¿Hacia dónde se conecta?: Utilizado por ProfileInfoCard.
class ProfileDateHelper {
  /// Convierte una fecha ISO (ej. 2000-05-15T00:00:00Z) a formato de pantalla (AAAA-MM-DD)
  static String toDisplayDate(String isoString) {
    if (isoString.isEmpty) return '';
    final parsed = DateTime.tryParse(isoString);
    if (parsed == null) return isoString;
    return '${parsed.year.toString().padLeft(4, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-'
        '${parsed.day.toString().padLeft(2, '0')}';
  }

  /// Convierte una fecha de pantalla (AAAA-MM-DD) a ISO 8601 (2000-05-15T00:00:00Z) para el backend
  static String toIsoDate(String displayText) {
    final clean = displayText.trim();
    if (clean.isEmpty) return '';
    final parsed = DateTime.tryParse(clean);
    if (parsed == null) return '';
    return '${parsed.year.toString().padLeft(4, '0')}-'
        '${parsed.month.toString().padLeft(2, '0')}-'
        '${parsed.day.toString().padLeft(2, '0')}T00:00:00Z';
  }

  /// Despliega el modal de calendario nativo y retorna la fecha seleccionada en AAAA-MM-DD
  static Future<String?> pickDate(BuildContext context, String currentDateText) async {
    final DateTime initial = DateTime.tryParse(currentDateText) ?? DateTime(2000, 1, 1);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'SELECCIONA TU FECHA DE NACIMIENTO',
      cancelText: 'CANCELAR',
      confirmText: 'SELECCIONAR',
    );

    if (picked == null) return null;
    return '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
  }
}
