// ==========================================
// Archivo: lib/src/features/user/presentation/providers/user_databases_provider.dart
// Qué hace: Administra el estado global de las bases de datos consumiendo únicamente la API real.
// Dónde se conecta: Consumido por DashboardPage, OverviewPage, DatabasesPage y CreateDatabaseDialog.
// De dónde recibe datos: Invoca a UserDatabasesRemoteDatasource y escucha el token de authProvider.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_databases_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';

/// Notificador de estado que administra la lista global de bases de datos del usuario desde la API
class UserDatabasesNotifier extends StateNotifier<List<DatabaseInstance>> {
  UserDatabasesNotifier({required this.datasource, required this.ref})
    : super(const []) {
    fetchDatabases();
  }

  final UserDatabasesRemoteDatasource datasource;
  final Ref ref;

  /// Obtiene el token JWT del usuario actualmente autenticado
  String? get _token => ref.read(authProvider).session?.accessToken;

  /// Consulta las bases de datos reales desde el servidor backend
  Future<String?> fetchDatabases() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      state = const [];
      return null;
    }
    try {
      final models = await datasource.getMyDatabases(token);
      state = models.map((m) => m.toEntity()).toList();
      return null; // Éxito
    } catch (e, stackTrace) {
      // 1. Log técnico preciso en la consola del desarrollador
      debugPrint('[UserDatabasesNotifier] Fallo al consultar GET /api/me/databases: $e');
      debugPrint('[StackTrace] $stackTrace');
      // Mantiene el estado anterior para no borrar lo que el usuario estaba viendo
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return errorMessage.isEmpty 
          ? 'Error al conectar con el servidor de bases de datos.' 
          : errorMessage;
    }
  }

  /// Revela la contraseña real de una instancia
  /// Imprime el error exacto en consola para el dev y retorna un mensaje amable para el usuario
  Future<({String? password, String? error})> revealPassword(int instanceId) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (password: null, error: 'Sesión expirada. Inicia sesión de nuevo.');
    }
    try {
      final password = await datasource.revealPassword(instanceId, token);
      return (password: password, error: null);
    } catch (e, stackTrace) {
      // 1. Registro técnico detallado en la consola del desarrollador (Terminal / Chrome DevTools)
      debugPrint('[UserDatabasesNotifier] Error al revelar contraseña para ID $instanceId: $e');
      debugPrint('[StackTrace] $stackTrace');
      // 2. Mensaje controlado y limpio que se retornará hacia la interfaz de usuario (UI)
      final userMessage = e.toString().replaceAll('ApiException: ', '');
      return (
        password: null,
        error: userMessage.isEmpty 
            ? 'No se pudo obtener la contraseña. Intenta nuevamente.' 
            : userMessage,
      );
    }
  }


  // ¿Qué hace?: Notificador Riverpod para la gestión de estado de BDs.
// ¿De dónde recibe datos?: Invocado desde los botones de la interfaz de usuario.
// ¿Dónde se conecta?: Llama al datasource remoto y actualiza el estado.
  /// Solicita el aprovisionamiento enviando el motor especificado
  Future<({Map<String, dynamic>? data, String? error})> createDatabase({
    String engine = 'SQL Server', // Motor por defecto
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (data: null, error: 'Sesión no válida. Por favor inicia sesión de nuevo.');
    }
    try {
      // Solicita al backend C# crear la instancia con el motor elegido
      final createdData = await datasource.createDatabase(
        engine: engine,
        token: token,
      );
      // Refresca la lista de bases de datos registradas
      await fetchDatabases();
      return (data: createdData, error: null); // Retorna los datos con éxito
    } catch (e) {
      return (
        data: null,
        error: e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

  /// Alterna el estado activo/inactivo de una instancia en la vista local
  void toggleInstanceState(String id) {
    state = [
      for (final db in state)
        if (db.id == id)
          DatabaseInstance(
            id: db.id,
            name: db.name,
            engine: db.engine,
            version: db.version,
            database: db.database,
            username: db.username,
            host: db.host,
            port: db.port,
            storageUsed: db.storageUsed,
            storageLimit: db.storageLimit,
            createdAt: db.createdAt,
            isRunning: !db.isRunning,
          )
        else
          db,
    ];
  }

  /// Elimina visualmente una instancia por su ID
  void deleteDatabase(String id) {
    state = state.where((db) => db.id != id).toList();
  }
}

/// Proveedor global de Riverpod para consultar y refrescar las BDs del usuario
final userDatabasesProvider =
    StateNotifierProvider<UserDatabasesNotifier, List<DatabaseInstance>>((ref) {
      final datasource = ref.watch(userDatabasesRemoteDatasourceProvider);
      return UserDatabasesNotifier(datasource: datasource, ref: ref);
    });
