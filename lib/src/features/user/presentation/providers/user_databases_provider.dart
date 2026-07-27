import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';

/// Notificador de estado que administra la lista global de bases de datos del usuario.
/// 
/// ¿Qué hace?: Permite listar, agregar, alternar encendido/apagado y eliminar instancias de BD.
/// ¿De dónde trae datos?: Carga datos de prueba iniciales (preparado para conectar ApiClient).
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por DashboardPage, OverviewPage, DatabasesPage y CreateDatabaseDialog.
class UserDatabasesNotifier extends StateNotifier<List<DatabaseInstance>> {
  UserDatabasesNotifier() : super(_initialInstances);

  // Lista inicial de instancias de prueba para el usuario
  static final List<DatabaseInstance> _initialInstances = [
    DatabaseInstance(
      id: 'db-101',
      name: 'api-tienda-demo',
      engine: 'PostgreSQL',
      version: '16',
      database: 'tienda_db',
      username: 'raft_user_84',
      host: 'postgresql84.raftdb.dev',
      port: 5432,
      storageUsed: 148,
      storageLimit: 512,
      createdAt: '18 Jul 2026',
      isRunning: true,
    ),
    DatabaseInstance(
      id: 'db-102',
      name: 'blog-universidad',
      engine: 'MySQL',
      version: '8.0',
      database: 'blog_db',
      username: 'raft_user_12',
      host: 'mysql12.raftdb.dev',
      port: 3306,
      storageUsed: 92,
      storageLimit: 512,
      createdAt: '20 Jul 2026',
      isRunning: true,
    ),
    DatabaseInstance(
      id: 'db-103',
      name: 'practica-consultas',
      engine: 'MongoDB',
      version: '7.0',
      database: 'practica_db',
      username: 'raft_user_44',
      host: 'mongodb44.raftdb.dev',
      port: 27017,
      storageUsed: 86,
      storageLimit: 512,
      createdAt: '22 Jul 2026',
      isRunning: false,
    ),
  ];

  /// Agrega una nueva base de datos al inicio de la lista
  void addDatabase(DatabaseInstance instance) {
    state = [instance, ...state];
  }

  /// Alterna el estado encendido / apagado de una instancia por su ID
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

  /// Elimina una instancia por su ID
  void deleteDatabase(String id) {
    state = state.where((db) => db.id != id).toList();
  }
}

/// Proveedor global de Riverpod para consultar y modificar las BDs del usuario
final userDatabasesProvider =
    StateNotifierProvider<UserDatabasesNotifier, List<DatabaseInstance>>((ref) {
  return UserDatabasesNotifier();
});
