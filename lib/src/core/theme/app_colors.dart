import 'package:flutter/material.dart';

/// ¿Qué hace?: Define los tokens de diseño y colores centralizados para Raft Day (Claro) y Raft Night (Oscuro).
/// ¿De dónde recibe datos?: Valores Hexadecimales especificados en colors_app.md.
/// ¿Dónde se conecta?: Consumido por app_theme.dart, componentes de layout y widgets de las páginas del usuario.
abstract class AppColors {
  // ==========================================
  //  RAFT DAY (Modo Claro)
  // ==========================================
  static const dayPrimary = Color(0xFF0D3B66); // Azul Marino principal
  static const dayPrimaryHover = Color(0xFF165D9C); // Hover sobre primario
  static const daySecondary = Color(0xFF2A9D8F); // Teal / Verde Agua
  static const dayAccent = Color(0xFF59B9E6); // Sky Blue acento
  static const dayBackground = Color(0xFFF8FAFC); // Fondo principal off-white
  static const daySurface = Color(0xFFFFFFFF); // Fondo de tarjetas y barras
  static const dayBorder = Color(0xFFD8E2EC); // Bordes suaves
  static const dayTextPrimary = Color(0xFF17324D); // Texto principal
  static const dayTextSecondary = Color(0xFF5C7187); // Texto secundario / muted

  // ==========================================
  //  RAFT NIGHT (Modo Oscuro)
  // ==========================================
  static const nightBackground = Color(0xFF09131F); // Midnight fondo oscuro
  static const nightSurface = Color(0xFF102235); // Deep Navy para contenedores
  static const nightCard = Color(
    0xFF183247,
  ); // Ocean Night para tarjetas elevadas
  static const nightPrimary = Color(0xFF5AB8FF); // Sky Blue primario en oscuro
  static const nightSecondary = Color(0xFF4EC8B8); // Aqua secundario en oscuro
  static const nightBorder = Color(0xFF28465F); // Navy Gray para bordes
  static const nightTextPrimary = Color(
    0xFFF5FAFF,
  ); // Texto blanco azulado principal
  static const nightTextSecondary = Color(
    0xFFA5BDD2,
  ); // Texto secundario gris azulado

  // ==========================================
  //  COLORES OFICIALES DE MOTORES DE BD
  // ==========================================
  // Modo Claro (Raft Day)
  static const mysqlDay = Color(0xFFF28C28);
  static const sqlServerDay = Color(0xFFD64545);
  static const mongoDbDay = Color(0xFF2F9E6D);
  static const postgresDay = Color(0xFF2C7BC9);

  // Modo Oscuro (Raft Night - Mayor luminosidad sin deslumbrar)
  static const mysqlNight = Color(0xFFF39C3D);
  static const sqlServerNight = Color(0xFFE05A5A);
  static const mongoDbNight = Color(0xFF41B883);
  static const postgresNight = Color(0xFF4EA5FF);

  // ==========================================
  //  ESTADOS Y ALERTAS
  // ==========================================
  static const success = Color(0xFF2F9E6D);
  static const warning = Color(0xFFF2A93B);
  static const error = Color(0xFFD64545);
  static const info = Color(0xFF4EA5D9);

  // ==========================================
  //  ALIAS DE COMPATIBILIDAD HACIA ATRÁS
  // (Previene errores de compilación en widgets antiguos)
  // ==========================================
  static const navy = dayPrimary;
  static const deepNavy = Color(0xFF071D45);
  static const blue = dayPrimary;
  static const cyan = Color(0xFF13C9C2);
  static const green = success;
  static const orange = warning;
  static const red = error;
  static const purple = Color(0xFF795BEF);
  static const background = dayBackground;
  static const surface = daySurface;
  static const text = dayTextPrimary;
  static const muted = dayTextSecondary;
  static const border = dayBorder;
}
