import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_theme.dart'; // Core: Mapeo Día/Noche

/// ¿Qué hace?: Asocia el nombre de un motor de base de datos con su icono gráfico y su color institucional adaptado a Raft Day / Raft Night.
/// ¿De dónde trae datos?: Ingesta la cadena del motor y la luminosidad (Brightness) desde el contexto del tema activo.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado por las tarjetas de bases de datos para pintar iconos y progresos de almacenamiento.
class EngineStyle {
  const EngineStyle(this.icon, this.color);

  final IconData icon; // Icono temático representativo del motor
  final Color color;   // Color institucional adaptado al brillo del tema activo
}

/// Función pura que mapea el motor a su estilo gráfico y su tono Día / Noche
EngineStyle engineStyle(String engine, [Brightness brightness = Brightness.light]) {
  final normalized = engine.toLowerCase().replaceAll(' ', '');

  // Obtiene el color oficial del motor según si el tema activo es claro u oscuro
  final dynamicColor = AppTheme.getEngineColor(engine, brightness);

  if (normalized.contains('postgres') || normalized.contains('pg')) {
    return EngineStyle(Icons.storage_rounded, dynamicColor);
  } else if (normalized.contains('mysql')) {
    return EngineStyle(Icons.dns_rounded, dynamicColor);
  } else if (normalized.contains('mongo')) {
    return EngineStyle(Icons.eco_rounded, dynamicColor);
  } else if (normalized.contains('sqlserver') || normalized.contains('mssql') || normalized.contains('sql')) {
    return EngineStyle(Icons.table_chart_rounded, dynamicColor);
  }

  return EngineStyle(Icons.dns_rounded, dynamicColor);
}



// import 'package:flutter/material.dart';
// import 'package:frontend_landing/src/core/theme/app_colors.dart';

// /// ¿Qué hace?: Asocia el nombre de un motor de base de datos con su icono gráfico y color oficial segun colors_app.md.
// /// ¿De dónde trae datos?: Ingesta los valores institucionales definidos en AppColors.
// /// ¿Hacia dónde va / Cómo se conecta?: Invocado por las tarjetas de bases de datos para pintar badges e insignias.
// class EngineStyle {
//   const EngineStyle(this.icon, this.color);

//   final IconData icon; // Icono temático fallback
//   final Color color;   // Color de marca institucional
// }

// /// Función pura que mapea la cadena del motor (MySQL, PostgreSQL, MongoDB, SQL Server) a su estilo gráfico
// EngineStyle engineStyle(String engine) {
//   final normalized = engine.toLowerCase().replaceAll(' ', '');

//   if (normalized.contains('postgres') || normalized.contains('pg')) {
//     return const EngineStyle(
//       Icons.storage_rounded,
//       AppColors.postgresDay, // 🟦 Azul oficial de PostgreSQL (#2C7BC9)
//     );
//   } else if (normalized.contains('mysql')) {
//     return const EngineStyle(
//       Icons.dns_rounded,
//       AppColors.mysqlDay, // 🟧 Naranja oficial de MySQL (#F28C28)
//     );
//   } else if (normalized.contains('mongo')) {
//     return const EngineStyle(
//       Icons.eco_rounded,
//       AppColors.mongoDbDay, // 🟩 Verde oficial de MongoDB (#2F9E6D)
//     );
//   } else if (normalized.contains('sqlserver') || normalized.contains('sql')) {
//     return const EngineStyle(
//       Icons.table_chart_rounded,
//       AppColors.sqlServerDay, // 🟥 Rojo oficial de Microsoft SQL Server (#D64545)
//     );
//   }

//   return const EngineStyle(
//     Icons.dns_rounded,
//     AppColors.dayPrimary,
//   );
// }
