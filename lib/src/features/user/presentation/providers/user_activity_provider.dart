// ==========================================
// Qué hace: Administra, emite y persiste las últimas 10 actividades del usuario autenticado, aisladas por su ID.
// De dónde recibe datos: Acciones del usuario e ingesta desde SharedPreferences indexada por userId de authProvider.
// Hacia dónde se conecta: Consumido por ActivitySection en OverviewPage y reseteado/reconstruido por authProvider.
// ==========================================

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tipos de eventos conocidos para mapear iconos y paletas temáticas
enum ActivityType {
  dbCreated,        // Creación de BD -> Icono de suma
  credentialViewed, // Consulta de credencial -> Icono de llave
  dbStopped,        // BD Detenida -> Icono de pausa
  dnsUpdated,       // DNS / Subdominios -> Icono de web/globo
  n8nExecuted,      // Workflow N8N -> Icono de rayo
  login,            // Inicio de sesión -> Icono de escudo
  generic,          // Evento genérico -> Icono de reloj
}

/// Modelo de datos para representar una actividad individual en el historial del usuario
class UserActivityItem {
  final String id;          // Identificador único de la actividad
  final String title;       // Título corto del evento (ej: "BD Creada")
  final String desc;        // Descripción detallada de la acción realizada
  final String time;        // Texto de tiempo transcurrido (ej: "Hace un momento")
  final ActivityType type;  // Tipo de evento para mapear icono y paleta temática

  UserActivityItem({
    required this.id,
    required this.title,
    required this.desc,
    required this.time,
    this.type = ActivityType.generic,
  });

  /// Devuelve el icono distintivo según el tipo de actividad
  IconData get icon {
    switch (type) {
      case ActivityType.dbCreated:
        return Icons.add_circle_outline_rounded;
      case ActivityType.credentialViewed:
        return Icons.key_outlined;
      case ActivityType.dbStopped:
        return Icons.pause_circle_outline_rounded;
      case ActivityType.dnsUpdated:
        return Icons.language_rounded;
      case ActivityType.n8nExecuted:
        return Icons.bolt_rounded;
      case ActivityType.login:
        return Icons.security_rounded;
      case ActivityType.generic:
        return Icons.history_rounded;
    }
  }

  /// Devuelve el color dinámico y responsivo según el modo activo (Día vs Noche)
  Color getColor(bool isDark) {
    switch (type) {
      case ActivityType.dbCreated:
      case ActivityType.login:
        return isDark ? const Color(0xFF4ECCA3) : const Color(0xFF2A9D8F);
      case ActivityType.credentialViewed:
      case ActivityType.dnsUpdated:
        return isDark ? const Color(0xFF64B5F6) : const Color(0xFF2C7BC9);
      case ActivityType.dbStopped:
      case ActivityType.n8nExecuted:
        return isDark ? const Color(0xFFFFB74D) : const Color(0xFFF28C28);
      case ActivityType.generic:
        return isDark ? const Color(0xFF4ECCA3) : const Color(0xFF2A9D8F);
    }
  }

  /// Serializa la actividad a Map para guardar en JSON
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc': desc,
      'time': time,
      'type': type.name,
    };
  }

  /// Deserializa un Map desde JSON de forma segura
  factory UserActivityItem.fromMap(Map<String, dynamic> map) {
    final typeString = map['type'] as String? ?? 'generic';
    final matchedType = ActivityType.values.firstWhere(
      (e) => e.name == typeString,
      orElse: () => ActivityType.generic,
    );

    return UserActivityItem(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      desc: map['desc'] as String? ?? '',
      time: map['time'] as String? ?? 'Hace un momento',
      type: matchedType,
    );
  }
}

/// Notificador de estado que administra y persiste las actividades del usuario autenticado (aislado por userId)
class UserActivityNotifier extends StateNotifier<List<UserActivityItem>> {
  UserActivityNotifier(this.ref) : super([]) {
    _loadFromStorage();
  }

  final Ref ref;
  static const int _maxItems = 10;

  /// Extrae el ID del usuario actualmente autenticado desde authProvider
  String? get _userId => ref.read(authProvider).session?.user.id;

  /// Genera una clave única en SharedPreferences indexada por el ID del usuario
  String get _storageKey => 'user_recent_activities_${_userId ?? 0}';

  /// Carga las actividades exclusivas del usuario actual desde SharedPreferences
  Future<void> _loadFromStorage() async {
    final uid = _userId;
    if (uid == null) {
      state = [];
      return;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
        state = decodedList
            .map((item) => UserActivityItem.fromMap(item as Map<String, dynamic>))
            .take(_maxItems)
            .toList();
      } else {
        _initializeDefaultActivities();
      }
    } catch (_) {
      _initializeDefaultActivities();
    }
  }

  /// Inicializa eventos de bienvenida por defecto aislados para el nuevo usuario
    /// Inicializa un único evento de bienvenida por defecto para cuentas totalmente nuevas
  void _initializeDefaultActivities() {
    state = [
      UserActivityItem(
        id: '1',
        title: 'Bienvenido a Raft DB',
        desc: 'Tu entorno de bases de datos distribuidas está activo y listo',
        time: 'Hace un momento',
        type: ActivityType.generic,
      ),
    ];
    _saveToStorage();
  }


  /// Guarda la lista actual en SharedPreferences bajo la clave del userId activo
  Future<void> _saveToStorage() async {
    if (_userId == null) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> mapList = state.map((item) => item.toMap()).toList();
      await prefs.setString(_storageKey, jsonEncode(mapList));
    } catch (_) {
      // Silencioso
    }
  }

  /// Registra una nueva actividad aislada para el usuario actual (Máx 10)
  void addActivity({
    required String title,
    required String desc,
    ActivityType type = ActivityType.generic,
    String time = 'Hace un momento',
  }) {
    if (_userId == null) return;

    final newItem = UserActivityItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      desc: desc,
      time: time,
      type: type,
    );

    state = [newItem, ...state.take(_maxItems - 1)];
    _saveToStorage();
  }

  /// Limpia la lista del usuario actual en memoria y disco al cerrar sesión
  Future<void> clearActivities() async {
    state = [];
    if (_userId != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
    }
  }
}

/// Proveedor global de Riverpod reactivo que recrea el notificador al cambiar de usuario
final userActivityProvider =
    StateNotifierProvider<UserActivityNotifier, List<UserActivityItem>>((ref) {
  // Escucha el ID del usuario autenticado para re-ejecutar la instanciación al cambiar de sesión
  ref.watch(authProvider.select((s) => s.session?.user.id));
  return UserActivityNotifier(ref);
});
