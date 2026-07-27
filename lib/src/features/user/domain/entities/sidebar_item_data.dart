import 'package:flutter/material.dart';

/// Modelo de datos liviano para configurar los botones del menú lateral (Sidebar).
class SidebarItemData {
  const SidebarItemData({
    required this.title,
    required this.icon,
  });

  final String title; // Texto visible de la opción (ej. Resumen)
  final IconData icon;// Icono de la opción de navegación
}
