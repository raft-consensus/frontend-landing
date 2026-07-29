// ==========================================
// Archivo: lib/src/features/user/presentation/providers/user_databases_provider.dart
// Qué hace: Administra el estado global de las bases de datos consumiendo únicamente la API real.
// Dónde se conecta: Consumido por DashboardPage, OverviewPage, DatabasesPage y CreateDatabaseDialog.
// De dónde recibe datos: Invoca a UserDatabasesRemoteDatasource y escucha el token de authProvider.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_databases_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/data/models/provisioning_result_model.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';

/// Resultado de solicitar la creación de una instancia. Cuando [success] es true,
/// [provisioning] trae la contraseña en texto plano — la UI debe mostrarla una única vez,
/// porque no se puede volver a recuperar en texto plano después de esta respuesta.
class CreateDatabaseResult {
  const CreateDatabaseResult._({
    required this.success,
    this.provisioning,
    this.errorMessage,
  });

  factory CreateDatabaseResult.success(ProvisioningResultModel provisioning) =>
      CreateDatabaseResult._(success: true, provisioning: provisioning);

  factory CreateDatabaseResult.failure(String errorMessage) =>
      CreateDatabaseResult._(success: false, errorMessage: errorMessage);

  final bool success;
  final ProvisioningResultModel? provisioning;
  final String? errorMessage;
}

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

  /// Solicita el aprovisionamiento de una nueva instancia MySQL propia (POST /api/me/databases).
  /// No recibe nombre ni motor: el backend solo aprovisiona MySQL hoy y genera todo server-side.
  Future<CreateDatabaseResult> createDatabase() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return CreateDatabaseResult.failure(
        'Sesión no válida. Por favor inicia sesión de nuevo.',
      );
    }

    try {
      final provisioning = await datasource.createDatabase(token: token);

      // Refresca desde el GET real en vez de construir la entidad a mano: la respuesta de
      // creación no trae status/usedSpaceBytes/maxSpaceBytes/createdAt, así que el dashboard
      // (cuotas, actividad, etc.) debe salir siempre de la fuente de verdad (GET /me/databases).
      await fetchDatabases();

      return CreateDatabaseResult.success(provisioning);
    } catch (e) {
      // Retorna el mensaje exacto entregado por la API para mostrárselo al usuario
      return CreateDatabaseResult.failure(
        e.toString().replaceAll('ApiException: ', ''),
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
