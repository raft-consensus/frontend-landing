// ==========================================
// Archivo: lib/src/features/user/presentation/providers/user_databases_provider.dart
// Qué hace: Administra el estado global de las bases de datos consumiendo únicamente la API real.
// Dónde se conecta: Consumido por DashboardPage, OverviewPage, DatabasesPage y CreateDatabaseDialog.
// De dónde recibe datos: Invoca a UserDatabasesRemoteDatasource y escucha el token de authProvider.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_databases_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';

/// Notificador de estado que administra la lista global de bases de datos del usuario desde la API
class UserDatabasesNotifier extends StateNotifier<List<DatabaseInstance>> {
  UserDatabasesNotifier({
    required this.datasource,
    required this.ref,
  }) : super(const []) {
    fetchDatabases();
  }

  final UserDatabasesRemoteDatasource datasource;
  final Ref ref;

  /// Obtiene el token JWT del usuario actualmente autenticado
  String? get _token => ref.read(authProvider).session?.accessToken;

  /// Consulta las bases de datos reales desde el servidor backend (GET /api/me/databases)
  Future<void> fetchDatabases() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      state = const [];
      return;
    }

    try {
      final models = await datasource.getMyDatabases(token);
      state = models.map((m) => m.toEntity()).toList();
    } catch (_) {
      state = const []; // Si no hay datos o la respuesta está vacía, el estado queda limpio
    }
  }

  /// Revela la contraseña real de una instancia (GET /api/me/databases/{id}/password)
  Future<String?> revealPassword(int instanceId) async {
    final token = _token;
    if (token == null || token.isEmpty) return null;

    try {
      return await datasource.revealPassword(instanceId, token);
    } catch (e) {
      return null;
    }
  }

  /// Solicita la creación de una nueva instancia mediante la API (POST /api/database-instances)
    /// Solicita la creación de una nueva instancia a la API real y devuelve el mensaje de error si la API rechaza la solicitud
  Future<String?> createDatabase({
    required String name,
    required String engine,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return 'Sesión no válida. Por favor inicia sesión de nuevo.';
    }

    try {
      final newModel = await datasource.createDatabase(
        name: name,
        engine: engine,
        token: token,
      );
      
      // Si la API responde exitosamente, agrega el objeto real devuelto a la lista local
      state = [newModel.toEntity(), ...state];
      return null; // null significa éxito total
    } catch (e) {
      // Retorna el mensaje exacto entregado por la API para mostrárselo al usuario
      return e.toString().replaceAll('ApiException: ', '');
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
