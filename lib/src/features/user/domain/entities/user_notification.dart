// ==========================================
// Que hace: Entidad pura de dominio que modela una notificacion del sistema Raft Cloud.
// De donde trae datos: Instanciada por UserNotificationsProvider ante eventos o telemetria.
// Donde se conecta: Consumida por providers y widgets de notificaciones.
// ==========================================

import 'package:flutter/material.dart';

/// Modelo inmutable de una notificacion del usuario
class UserNotification {
  final String id; // Identificador unico de la notificacion
  final String title; // Titulo principal del mensaje
  final String description; // Detalle explicativo de la notificacion
  final String time; // Texto de tiempo transcurrido (ej: "Hace 5 min")
  final Color color; // Color distintivo segun el nivel de severidad
  final bool isRead; // Estado de lectura: true (leida) / false (no leida)

  const UserNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
    this.isRead = false,
  });

  /// Retorna una copia con campos modificados
  UserNotification copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    Color? color,
    bool? isRead,
  }) {
    return UserNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      color: color ?? this.color,
      isRead: isRead ?? this.isRead,
    );
  }
}
