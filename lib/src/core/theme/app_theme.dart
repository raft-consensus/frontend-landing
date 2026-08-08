import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Configuración centralizada de los temas visuales ThemeData (Raft Day y Raft Night).
/// ¿De dónde trae datos?: Ingesta los tokens de color definidos en AppColors.
/// ¿Hacia dónde va / Cómo se conecta?: Se asigna a MaterialApp.router en main.dart y provee Theme.of(context) a la app.
abstract class AppTheme {
  /// Tema 🌊 Raft Day (Modo Claro)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.dayBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.dayPrimary,
        onPrimary: Colors.white,
        secondary: AppColors.daySecondary,
        onSecondary: Colors.white,
        surface: AppColors.daySurface,
        onSurface: AppColors.dayTextPrimary,
        outline: AppColors.dayBorder,
        error: AppColors.error,
      ),
      dividerColor: AppColors.dayBorder,
      cardColor: AppColors.daySurface,
      dividerTheme: const DividerThemeData(
        color: AppColors.dayBorder,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.daySurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.dayBorder),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.dayTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.dayTextPrimary,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: AppColors.dayTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: AppColors.dayTextSecondary,
        ),
      ),
    );
  }

  /// Tema 🌌 Raft Night (Modo Oscuro)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.nightBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.nightPrimary,
        onPrimary: AppColors.nightBackground,
        secondary: AppColors.nightSecondary,
        onSecondary: AppColors.nightBackground,
        surface: AppColors.nightSurface,
        onSurface: AppColors.nightTextPrimary,
        outline: AppColors.nightBorder,
        error: AppColors.error,
      ),
      dividerColor: AppColors.nightBorder,
      cardColor: AppColors.nightCard,
      dividerTheme: const DividerThemeData(
        color: AppColors.nightBorder,
        thickness: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.nightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: AppColors.nightBorder),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.nightTextPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.nightTextPrimary,
          fontWeight: FontWeight.w800,
        ),
        bodyLarge: TextStyle(
          color: AppColors.nightTextPrimary,
        ),
        bodyMedium: TextStyle(
          color: AppColors.nightTextSecondary,
        ),
      ),
    );
  }

  /// Helper utilitario para obtener el color dinámico del motor según el tema activo
  static Color getEngineColor(String engine, Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final normalized = engine.toLowerCase().replaceAll(' ', '');

    // 1. Evalúa PostgreSQL primero para evitar falsos positivos con "sql"
    if (normalized.contains('postgres') || normalized.contains('pg')) {
      return isDark ? AppColors.postgresNight : AppColors.postgresDay; // 🟦 Azul oficial
    } else if (normalized.contains('mysql')) {
      return isDark ? AppColors.mysqlNight : AppColors.mysqlDay;       // 🟧 Naranja oficial
    } else if (normalized.contains('mongo')) {
      return isDark ? AppColors.mongoDbNight : AppColors.mongoDbDay;   // 🟩 Verde oficial
    } else if (normalized.contains('sqlserver') || normalized.contains('mssql') || normalized == 'sql') {
      return isDark ? AppColors.sqlServerNight : AppColors.sqlServerDay; // 🟥 Rojo oficial
    }
    return isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
  }
}
