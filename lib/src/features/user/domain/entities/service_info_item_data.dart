// ==========================================
// Que hace: Entidad inmutable que modela un bloque tematico de informacion documental.
// De donde trae datos: Catalogos estaticos de informacion para cada servicio.
// Donde se conecta: Consumido por ServiceInfoBlock.
// ==========================================

import 'package:flutter/material.dart';

/// Modelo de datos para un cuadrante informativo de un servicio
class ServiceInfoItemData {
  const ServiceInfoItemData({
    required this.title, // Titulo del bloque
    required this.icon, // Icono representativo
    required this.color, // Color tematico
    required this.items, // Lista de lineas o puntos clave
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
}
