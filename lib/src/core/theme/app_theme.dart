import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Configuración centralizada del tema visual de la aplicación.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.blue,
        primary: AppColors.navy,
        secondary: AppColors.cyan,
        surface: Colors.white,
      ),
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 58,
          fontWeight: FontWeight.w900,
          height: 1.04,
          color: AppColors.navy,
        ),
        headlineLarge: TextStyle(
          fontSize: 38,
          fontWeight: FontWeight.w900,
          color: AppColors.navy,
        ),
        headlineMedium: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w800,
          color: AppColors.navy,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: AppColors.navy,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          height: 1.65,
          color: Color(0xFF52647C),
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.55,
          color: Color(0xFF607189),
        ),
      ),
    );
  }
}
