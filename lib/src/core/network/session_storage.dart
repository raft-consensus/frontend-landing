import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Servicio responsable del almacenamiento persistente de las credenciales de sesión (JWT).
/// 
/// ¿De dónde recibe datos?: De SharedPreferences (disco local/Web LocalStorage).
/// ¿Hacia dónde va / Dónde se conecta?: Es consumido por AuthRepositoryImpl y ApiClient mediante sessionStorageProvider.
class SessionStorage {
  static const String _tokenKey = 'jwt_token';

  /// Guarda el token JWT en el almacenamiento persistente.
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Recupera el token JWT guardado. Retorna null si no hay sesión activa.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Elimina todo el almacenamiento local para asegurar un cierre de sesión limpio y sin caché.
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de SessionStorage.
final sessionStorageProvider = Provider<SessionStorage>((ref) {
  return SessionStorage();
});
