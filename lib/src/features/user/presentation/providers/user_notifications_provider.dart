// ==========================================
// Que hace: Administra el estado global de notificaciones activas del usuario y genera alertas automaticas de almacenamiento.
// De donde trae datos: Escucha userDatabasesProvider para evaluar la cuota de disco y registrar alertas.
// Donde se conecta: Consumido por DashboardTopbar (campana) y el modal NotificationsDialog.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/user_notification.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';

/// Notificador de estado Riverpod que administra las notificaciones activas del usuario
class UserNotificationsNotifier extends StateNotifier<List<UserNotification>> {
  UserNotificationsNotifier(this.ref) : super([]) {
    _initializeDefaultNotifications();
    _listenToDatabaseStorage();
  }

  final Ref ref; // Referencia para observar otros proveedores de Riverpod

  /// Carga notificaciones iniciales del sistema
  void _initializeDefaultNotifications() {
    state = const [
      UserNotification(
        id: '1',
        title: 'Bienvenido a Raft Cloud',
        description: 'Tu entorno de bases de datos distribuidas y servicios Cloud esta activo.',
        time: 'Hace 5 min',
        color: Color(0xFF10B981), // Verde exito
      ),
      UserNotification(
        id: '2',
        title: 'Guía de Conexión Rápida',
        description: 'Aprende a conectar PostgreSQL, Redis, MySQL y MongoDB desde tu aplicacion.',
        time: 'Hace 1 hora',
        color: Color(0xFF38BDF8), // Celeste info
      ),
    ];
  }

  /// Escucha el estado de bases de datos para evaluar automaticamente alertas de almacenamiento (> 85%)
  void _listenToDatabaseStorage() {
    ref.listen(userDatabasesProvider, (previous, next) {
      final int totalUsedBytes = next.fold(0, (sum, db) => sum + db.usedSpaceBytes);
      final int totalLimitBytes = next.fold(0, (sum, db) => sum + db.maxSpaceBytes);

      if (totalLimitBytes > 0) {
        final double percentage = (totalUsedBytes / totalLimitBytes) * 100;

        // Si el consumo supera el 85%, genera o actualiza la alerta automatica
        if (percentage >= 85) {
          addNotification(
            id: 'storage_alert',
            title: 'Almacenamiento Crítico',
            description: 'Has alcanzado el ${percentage.toInt()}% de tu cuota de disco asignada.',
            color: const Color(0xFFEF4444), // Rojo alerta
          );
        }
      }
    });
  }

  /// Agrega una nueva notificacion a la lista
  void addNotification({
    required String id,
    required String title,
    required String description,
    required Color color,
    String time = 'Ahora mismo',
  }) {
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

  /// Marca todas las notificaciones como leidas
  void markAllAsRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true),
    ];
  }

  /// Elimina una notificacion por su ID
  void removeNotification(String id) {
    state = state.where((n) => n.id != id).toList();
  }
}

/// Proveedor global de Riverpod para notificaciones
final userNotificationsProvider =
    StateNotifierProvider<UserNotificationsNotifier, List<UserNotification>>((ref) {
      return UserNotificationsNotifier(ref);
    });

/// Proveedor derivado con contador de no leidas
final unreadNotificationsCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(userNotificationsProvider);
  return notifications.where((n) => !n.isRead).length;
});
