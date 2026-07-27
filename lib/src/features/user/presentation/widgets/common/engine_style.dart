import 'package:flutter/material.dart';

/// ¿Qué hace?: Helper y función pura que asocia el nombre de un motor de BD con su icono y color de marca.
/// ¿Cómo se conecta?: Es invocado por EngineIcon para saber de qué color e icono pintar motores como PostgreSQL o MongoDB.
class EngineStyle {
  const EngineStyle(this.icon, this.color);

  final IconData icon; // Icono gráfico del motor
  final Color color;   // Color institucional del motor
}

/// Función que mapea la cadena del motor a su configuración gráfica (icono + color)
EngineStyle engineStyle(String engine) {
  switch (engine) {
    case 'PostgreSQL':
      return const EngineStyle(
        Icons.storage_rounded,
        Color(0xFF3977A8), // Azul oficial de marca PostgreSQL
      );
    case 'MySQL':
      return const EngineStyle(
        Icons.dns_rounded,
        Color(0xFF1177DD), // Azul oficial de marca MySQL
      );
    case 'SQL Server':
      return const EngineStyle(
        Icons.table_chart_rounded,
        Color(0xFFE95462), // Rojo institucional Microsoft SQL Server
      );
    case 'MongoDB':
      return const EngineStyle(
        Icons.eco_rounded,
        Color(0xFF17B978), // Verde hoja oficial MongoDB
      );
    default:
      return const EngineStyle(
        Icons.storage_rounded,
        Color(0xFF687A91), // Color gris genérico por defecto
      );
  }
}
