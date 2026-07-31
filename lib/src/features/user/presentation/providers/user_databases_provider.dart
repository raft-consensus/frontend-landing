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
  UserDatabasesNotifier({required this.datasource, required this.ref})
    : super(const []) {
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
      state =
          const []; // Si no hay datos o la respuesta está vacía, el estado queda limpio
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

  /// Solicita el aprovisionamiento de una nueva instancia a la API real y refresca el estado
  ///
  /// ¿De dónde recibe datos?: Invocado por el botón "Crear Base de Datos" en Dashboard/Databases page.
  /// ¿Hacia dónde va?: Llama al RemoteDataSource y ejecuta fetchDatabases() al finalizar con éxito.
  Future<String?> createDatabase() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return 'Sesión no válida. Por favor inicia sesión de nuevo.';
    }

    try {
      // Envía la orden de aprovisionamiento al backend
      await datasource.createDatabase(token: token);

      // Refresca la lista completa de bases de datos desde el backend
      await fetchDatabases();

      return null; // null indica que se creó con éxito
    } catch (e) {
      // Retorna el mensaje exacto entregado por el backend (ej: si excedió el límite de BDs por cuenta)
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
