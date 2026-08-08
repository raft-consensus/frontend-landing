import 'package:flutter/foundation.dart';

/// ¿Qué hace?: Entidad de dominio pura que representa un flujo de trabajo individual de n8n.
/// ¿De dónde trae datos?: Inmutable, se construye a partir de las respuestas JSON del backend o mock.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza dentro de N8nServiceData y se renderiza en la tabla N8nWorkflowsList.
@immutable
class N8nWorkflow {
  final String id;              // Identificador único del flujo (ej: "wf_01")
  final String name;            // Nombre descriptivo del flujo (ej: "Notificación de Backup")
  final String trigger;         // Tipo de disparador que inicia el flujo (ej: "Raft DB Webhook", "Cron 00:00")
  final bool isActive;          // Estado del flujo: true si está activo y ejecutándose, false si está pausado
  final DateTime lastExecutedAt; // Fecha y hora exacta de la última vez que se ejecutó el flujo
  final int executionCount;     // Cantidad total de ejecuciones acumuladas por este flujo

  const N8nWorkflow({
    required this.id,             // Requerido: ID del flujo
    required this.name,           // Requerido: Nombre del flujo
    required this.trigger,        // Requerido: Tipo de disparador
    required this.isActive,       // Requerido: Estado activo o inactivo
    required this.lastExecutedAt, // Requerido: Fecha de última ejecución
    this.executionCount = 0,      // Opcional: Total de ejecuciones (por defecto 0)
  });

  /// Permite crear una copia modificada del objeto manteniendo la inmutabilidad
  N8nWorkflow copyWith({
    String? id,                  // Nuevo ID opcional
    String? name,                // Nuevo nombre opcional
    String? trigger,             // Nuevo trigger opcional
    bool? isActive,              // Nuevo estado activo opcional
    DateTime? lastExecutedAt,    // Nueva fecha de ejecución opcional
    int? executionCount,         // Nuevo contador de ejecuciones opcional
  }) {
    return N8nWorkflow(
      id: id ?? this.id,                         // Mantiene el valor actual si no se pasa uno nuevo
      name: name ?? this.name,                   // Mantiene el nombre actual si no se pasa uno nuevo
      trigger: trigger ?? this.trigger,          // Mantiene el trigger actual si no se pasa uno nuevo
      isActive: isActive ?? this.isActive,       // Mantiene el estado actual si no se pasa uno nuevo
      lastExecutedAt: lastExecutedAt ?? this.lastExecutedAt, // Mantiene la fecha actual
      executionCount: executionCount ?? this.executionCount, // Mantiene el contador actual
    );
  }
}
