// ==========================================
// Qué hace: Gestor de estado reactivo para las API Keys del Servicio de IA conectándose con la API real C#.
// Dónde se conecta: Consumido por AiServicesPage, AiSummaryCards, AiToolbar y AiKeysTable.
// De dónde recibe datos: Invoca a UserAiRemoteDatasource y lee la sesión activa en authProvider.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_ai_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';

/// Notificador de estado para administrar API Keys reales desde el servidor C#
class UserAiNotifier extends StateNotifier<List<AiKey>> {
  UserAiNotifier({required this.datasource, required this.ref}) : super(const []) {
    fetchKeys();
  }

  final UserAiRemoteDatasource datasource; // Fuente de datos remota
  final Ref ref;                            // Referencia a Riverpod

  /// Obtiene el Token JWT de la sesión activa
  String? get _token => ref.read(authProvider).session?.accessToken;

  /// Carga las API Keys reales del usuario desde el servidor C# (GET /api/me/ai-keys)
  Future<String?> fetchKeys() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      state = const [];
      return null;
    }

    try {
      final models = await datasource.getAiKeys(token);
      state = models.map((m) => m.toEntity()).toList();
      return null;
    } catch (e, stackTrace) {
      debugPrint('[UserAiNotifier] Error al consultar GET /api/me/ai-keys: $e');
      debugPrint('[StackTrace] $stackTrace');
      return e.toString().replaceAll('ApiException: ', '');
    }
  }

  /// Crea una nueva API Key y devuelve el secreto completo (POST /api/me/ai-keys)
  Future<({String? secret, String? error})> createKey({required String name}) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (secret: null, error: 'Sesión expirada. Inicia sesión nuevamente.');
    }

    try {
      final data = await datasource.createAiKey(name, token);
      final secret = data['secret'] as String? ?? '';
      await fetchKeys(); // Refresca la lista real desde SQL Server
      return (secret: secret, error: null);
    } catch (e) {
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return (secret: null, error: errorMessage);
    }
  }

  /// Rota una API Key existente generando un nuevo secreto (POST /api/me/ai-keys/{id}/rotate)
  Future<({String? secret, String? error})> rotateKey(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return (secret: null, error: 'Sesión expirada. Inicia sesión nuevamente.');
    }

    try {
      final data = await datasource.rotateAiKey(id, token);
      final secret = data['secret'] as String? ?? '';
      await fetchKeys(); // Refresca la lista real desde SQL Server
      return (secret: secret, error: null);
    } catch (e) {
      final errorMessage = e.toString().replaceAll('ApiException: ', '');
      return (secret: null, error: errorMessage);
    }
  }

  /// Revoca/elimina una API Key existente (DELETE /api/me/ai-keys/{id})
  Future<String?> deleteKey(String id) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return 'Sesión expirada. Inicia sesión nuevamente.';
    }

    try {
      debugPrint('[UserAiNotifier] Enviando solicitud DELETE /api/me/ai-keys/$id');
      await datasource.deleteAiKey(id, token);
      await fetchKeys(); // Refresca la lista real desde SQL Server
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserAiNotifier] Error al revocar clave ID $id: $e');
      return e.toString().replaceAll('ApiException: ', '');
    }
  }
}

/// Provider global de Riverpod para las API Keys de IA
final userAiProvider = StateNotifierProvider<UserAiNotifier, List<AiKey>>((ref) {
  ref.watch(authProvider.select((s) => s.session?.user.id));
  final datasource = ref.watch(userAiRemoteDatasourceProvider);
  return UserAiNotifier(datasource: datasource, ref: ref);
});
