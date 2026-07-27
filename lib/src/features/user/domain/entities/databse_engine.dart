import 'package:flutter/material.dart';

/// Entidad pura de dominio que representa la metadata de un motor de BD disponible.
class DatabaseEngine {
  const DatabaseEngine({
    required this.name,
    required this.version,
    required this.port,
    required this.color,
    required this.icon,
  });

  final String name;     // Nombre comercial del motor (ej. PostgreSQL)
  final String version;  // Versión por defecto ofrecida (ej. 16)
  final int port;        // Puerto predeterminado del motor (ej. 5432)
  final Color color;     // Color oficial o representativo para la UI
  final IconData icon;   // Icono visual representativo en Flutter
}
