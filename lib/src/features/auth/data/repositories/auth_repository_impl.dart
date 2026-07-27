import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/session_storage.dart';
import 'package:frontend_landing/src/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/auth_session.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/login_form_data.dart';
import 'package:frontend_landing/src/features/auth/domain/entities/register_form_data.dart';

/// Implementación del repositorio de autenticación que orquesta la red y la persistencia local.
/// 
/// ¿De dónde recibe datos?: De AuthRemoteDataSource (peticiones API) y SessionStorage (JWT).
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por AuthNotifier / AuthProvider en la capa de presentación.
class AuthRepositoryImpl {
  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionStorage,
  });

  final AuthRemoteDataSource remoteDataSource;
  final SessionStorage sessionStorage;

  /// Ejecuta el registro, persiste el token recibido y retorna la sesión.
  Future<AuthSession> register(RegisterFormData formData) async {
    final session = await remoteDataSource.register(formData);
    if (session.accessToken.isNotEmpty) {
      await sessionStorage.saveToken(session.accessToken);
    }
    return session;
  }

  /// Ejecuta el inicio de sesión, persiste el token recibido y retorna la sesión.
  Future<AuthSession> login(LoginFormData formData) async {
    final session = await remoteDataSource.login(formData);
    if (session.accessToken.isNotEmpty) {
      await sessionStorage.saveToken(session.accessToken);
    }
    return session;
  }

  /// Cierra la sesión activa eliminando el token del almacenamiento local.
  Future<void> logout() async {
    await sessionStorage.clearSession();
  }

  /// Consulta si existe un token previamente guardado.
  Future<String?> getSavedToken() async {
    return sessionStorage.getToken();
  }
}

/// Proveedor de Riverpod para inyectar AuthRepositoryImpl.
final authRepositoryProvider = Provider<AuthRepositoryImpl>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final sessionStorage = ref.watch(sessionStorageProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    sessionStorage: sessionStorage,
  );
});
