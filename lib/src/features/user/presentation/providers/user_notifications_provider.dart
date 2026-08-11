// ==========================================
// Qué hace: Administra la lista de notificaciones activas del usuario y genera alertas automáticas de almacenamiento y eventos.
// Dónde se conecta: Consumido por DashboardTopbar (campana) y NotificationsDialog.
// De dónde recibe datos: Escucha userDatabasesProvider para evaluar la cuota de disco y registrar alertas.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';

/// Modelo de datos de una notificación individual del usuario
class UserNotification {
  final String id;          // Identificador único de la notificación
  final String title;       // Título principal del mensaje
  final String description; // Detalle explicativo de la notificación
  final String time;        // Texto de tiempo transcurrido (ej: "Hace 5 min")
  final Color color;        // Color distintivo según el nivel de severidad
  final bool isRead;        // Estado de lectura: true (leída) / false (no leída)

  UserNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
    this.isRead = false,
  });

  /// Crea una copia del objeto modificando atributos específicos
  UserNotification copyWith({
    bool? isRead,
  }) {
    return UserNotification(
      id: id,
      title: title,
      description: description,
      time: time,
      color: color,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Notificador de estado Riverpod que administra las notificaciones activas del usuario
class UserNotificationsNotifier extends StateNotifier<List<UserNotification>> {
  UserNotificationsNotifier(this.ref) : super([]) {
    _initializeDefaultNotifications();
    _listenToDatabaseStorage();
  }

  final Ref ref;

  /// Carga notificaciones iniciales del sistema
  void _initializeDefaultNotifications() {
    state = [
      UserNotification(
        id: '1',
        title: 'Bienvenido a Raft DB',
        description: 'Tu entorno de bases de datos distribuidas está activo.',
        time: 'Hace 5 min',
        color: AppColors.success,
      ),
      UserNotification(
        id: '2',
        title: 'Guía de Conexión',
        description: 'Aprende a conectar PostgreSQL y MySQL desde tu aplicación.',
        time: 'Hace 1 hora',
        color: AppColors.info,
      ),
    ];
  }

  /// Escucha el estado de bases de datos para evaluar automáticamente alertas de almacenamiento (> 85%)
  void _listenToDatabaseStorage() {
    ref.listen(userDatabasesProvider, (previous, next) {
      final int totalUsedBytes = next.fold(0, (sum, db) => sum + db.usedSpaceBytes);
      final int totalLimitBytes = next.fold(0, (sum, db) => sum + db.maxSpaceBytes);

      if (totalLimitBytes > 0) {
        final double percentage = (totalUsedBytes / totalLimitBytes) * 100;

        // Si el consumo supera el 85%, genera o actualiza la alerta automática
        if (percentage >= 85) {
          addNotification(
            id: 'storage_alert',
            title: 'Almacenamiento Crítico',
            description: 'Has alcanzado el ${percentage.toInt()}% de tu cuota de disco asignada.',
            color: AppColors.error,
          );
        }
      }
    });
  }

  /// Agrega una nueva notificación a la lista (o reemplaza si ya existe por ID)
  void addNotification({
    required String id,
    required String title,
    required String description,
    required Color color,
    String time = 'Ahora mismo',
  }) {
    // Si ya existe una notificación con el mismo ID, la actualiza
    final exists = state.any((n) => n.id == id);
    if (exists) {
      state = [
        for (final item in state)
          if (item.id == id)
            UserNotification(
              id: id,
              title: title,
              description: description,
              time: time,
              color: color,
              isRead: false,
            )
          else
            item,
      ];
    } else {
      state = [
        UserNotification(
          id: id,
          title: title,
          description: description,
          time: time,
          color: color,
          isRead: false,
        ),
        ...state,
      ];
    }
  }

  /// Marca todas las notificaciones como leídas
  void markAllAsRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true),
    ];
  }

  /// Elimina una notificación por su ID
  void removeNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

/// Proveedor global de Riverpod para administrar la lista de notificaciones del usuario
final userNotificationsProvider =
    StateNotifierProvider<UserNotificationsNotifier, List<UserNotification>>((ref) {
      return UserNotificationsNotifier(ref);
    });

/// Proveedor derivado que calcula la cantidad de notificaciones no leídas
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(userNotificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});
