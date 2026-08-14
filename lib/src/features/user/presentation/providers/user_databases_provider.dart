// ==========================================
// Qué hace: Administra el estado global de las bases de datos consumiendo únicamente la API real.
// Dónde se conecta: Consumido por DashboardPage, OverviewPage, DatabasesPage y CreateDatabaseDialog.
// De dónde recibe datos: Invoca a UserDatabasesRemoteDatasource y escucha el token/id de authProvider.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_databases_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_activity_provider.dart';

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
      debugPrint('[UserDatabasesNotifier] Fallo al consultar GET /api/me/databases: $e');
      debugPrint('[StackTrace] $stackTrace');
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return errorMessage.isEmpty 
          ? 'Error al conectar con el servidor de bases de datos.' 
          : errorMessage;
    }
  }

  /// Revela la contraseña real de una instancia
  Future<({String? password, String? error})> revealPassword(int instanceId) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (password: null, error: 'Sesión expirada. Inicia sesión de nuevo.');
    }
    try {
      final password = await datasource.revealPassword(instanceId, token);
      // REGISTRAR ACTIVIDAD
      ref.read(userActivityProvider.notifier).addActivity(
        title: 'Credenciales Consultadas',
        desc: 'Consultaste la contraseña de una instancia',
        type: ActivityType.credentialViewed,
      );
      return (password: password, error: null);
    } catch (e, stackTrace) {
      debugPrint('[UserDatabasesNotifier] Error al revelar contraseña para ID $instanceId: $e');
      debugPrint('[StackTrace] $stackTrace');
      final userMessage = e.toString().replaceAll('ApiException: ', '');
      return (
        password: null,
        error: userMessage.isEmpty 
            ? 'No se pudo obtener la contraseña. Intenta nuevamente.' 
            : userMessage,
      );
    }
  }

  /// Solicita el aprovisionamiento enviando el motor especificado
  Future<({Map<String, dynamic>? data, String? error})> createDatabase({
    String engine = 'SQL Server',
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (data: null, error: 'Sesión no válida. Por favor inicia sesión de nuevo.');
    }
    try {
      final createdData = await datasource.createDatabase(
        engine: engine,
        token: token,
      );
      await fetchDatabases();
      final newDbName = createdData['databaseName']?.toString() ?? engine;
      // REGISTRAR ACTIVIDAD
      ref.read(userActivityProvider.notifier).addActivity(
        title: 'BD Creada',
        desc: 'Creaste la instancia "$newDbName"',
        type: ActivityType.dbCreated,
      );
      return (data: createdData, error: null);
    } catch (e) {
      return (
        data: null,
        error: e.toString().replaceAll('ApiException: ', ''),
      );
    }
  }

    /// Alterna el estado activo/detenido invocando el backend C# (/pause o /resume)
  Future<({bool success, String? error})> toggleInstanceState(String id, bool currentlyRunning) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (success: false, error: 'Sesión expirada. Inicia sesión de nuevo.');
    }

    // Cláusula de guarda: Si el motor es MySQL, no se realiza ninguna petición HTTP
    final currentDb = state.where((db) => db.id == id).firstOrNull;
    if (currentDb != null && currentDb.engine.trim().toLowerCase() == 'mysql') {
      return (
        success: false,
        error: 'La opción de pausar/iniciar no está disponible para instancias MySQL.',
      );
    }

    final instanceIdInt = int.tryParse(id) ?? 0;
    try {
      if (currentlyRunning) {
        await datasource.pauseDatabase(instanceIdInt, token);
        // REGISTRAR ACTIVIDAD (Pausa)
        ref.read(userActivityProvider.notifier).addActivity(
          title: 'Instancia Detenida',
          desc: 'Detuviste una instancia de base de datos',
          type: ActivityType.dbStopped,
        );
      } else {
        await datasource.resumeDatabase(instanceIdInt, token);
        // REGISTRAR ACTIVIDAD (Reanudar)
        ref.read(userActivityProvider.notifier).addActivity(
          title: 'Instancia Reanudada',
          desc: 'Reanudaste una instancia de base de datos',
          type: ActivityType.dbCreated,
        );
      }
      await fetchDatabases(); // Refresca la lista real desde el servidor C#
      return (success: true, error: null);
    } catch (e) {
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return (success: false, error: errorMessage);
    }
  }

  /// Elimina definitivamente una instancia llamando a DELETE /api/me/databases/{id}
  Future<({bool success, String? error})> deleteDatabase(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (success: false, error: 'Sesión expirada. Inicia sesión de nuevo.');
    }
    final instanceIdInt = int.tryParse(id) ?? 0;
    try {
      await datasource.deleteDatabase(instanceIdInt, token);
      // REGISTRAR ACTIVIDAD
      ref.read(userActivityProvider.notifier).addActivity(
        title: 'Instancia Eliminada',
        desc: 'Eliminaste una instancia de base de datos',
        type: ActivityType.dbStopped,
      );
      await fetchDatabases(); // Refresca la lista real desde el servidor C#
      return (success: true, error: null);
    } catch (e) {
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return (success: false, error: errorMessage);
    }
  }
} //  La clase UserDatabasesNotifier cierra AQUÍ

/// Proveedor global de Riverpod para consultar y refrescar las BDs del usuario
final userDatabasesProvider =
    StateNotifierProvider<UserDatabasesNotifier, List<DatabaseInstance>>((ref) {
      ref.watch(authProvider.select((s) => s.session?.user.id));
      final datasource = ref.watch(userDatabasesRemoteDatasourceProvider);
      return UserDatabasesNotifier(datasource: datasource, ref: ref);
    });
