import 'package:flutter/material.dart';

/// Clase abstracta para almacenar la paleta de colores base de Raft DB.
/// Al ser constantes (const), Flutter optimiza el renderizado y evita recrear objetos en memoria.
abstract class AppColors {
  /// Color Azul Oscuro / Navy principal para textos de títulos y fondos oscuros.
  static const navy = Color(0xFF061D4F);

  /// Color Azul secundario utilizado en botones, gradientes e iconos.
  static const blue = Color(0xFF0878D1);

  /// Color Cyan de acento para antetítulos, detalles y estado de componentes.
  static const cyan = Color(0xFF0CC7C4);

  /// Color de fondo general (azul muy claro casi blanco) para la aplicación.
  static const background = Color(0xFFF4F9FF);
}
