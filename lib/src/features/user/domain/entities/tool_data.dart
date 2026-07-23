import 'package:flutter/material.dart';

/// ¿Qué hace?: Entidad de dominio que define la estructura de una herramienta de desarrollo en el portal.
/// ¿De dónde trae?: Consume Flutter Framework (IconData).
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en ToolsPage y ToolCard para estructurar el catálogo de herramientas.
class ToolData {
  const ToolData({
    required this.title,       // Nombre de la herramienta (ej. pgAdmin Web)
    required this.category,    // Categoría temática (ej. Relacional, NoSQL, ORM / GUI)
    required this.description, // Descripción funcional corta
    required this.icon,        // Icono característico
    this.badge,                // Insignia opcional (ej. "Pro", "Disponible")
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final String? badge;
}
