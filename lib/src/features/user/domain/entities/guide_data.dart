import 'package:flutter/material.dart';

/// ¿Qué hace?: Entidad de dominio que define la estructura de un tutorial o guía de conexión en el portal.
/// ¿De dónde trae?: Consume Flutter Framework (IconData).
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza dentro de DocumentationPage y GuideCard.
class GuideData {
  const GuideData({
    required this.title,       // Título del tutorial (ej. Conexión desde Flutter)
    required this.language,    // Lenguaje/Tecnología (ej. Flutter, Node.js, Python, Java)
    required this.description, // Explicación resumida de la guía
    required this.time,        // Tiempo estimado de lectura (ej. "3 min")
    required this.icon,        // Icono característico del lenguaje
    required this.codeSnippet, // Código de ejemplo copiable
  });

  final String title;
  final String language;
  final String description;
  final String time;
  final IconData icon;
  final String codeSnippet;
}
