import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';

/// ¿Qué hace?: Gestor de estado reactivo para las API Keys del Servicio de IA usando Riverpod.
/// ¿De dónde recibe datos?: Lee la sesión de authProvider y se conecta con los endpoints del backend.
/// ¿Hacia dónde va / Cómo se conecta?: Consumido por AiServicesPage, AiSummaryCards, AiToolbar y AiKeysTable.
class UserAiNotifier extends StateNotifier<List<AiKey>> {
  UserAiNotifier({required this.ref}) : super(const []) {
    fetchKeys();
  }

  final Ref ref;

  /// Obtiene el Token JWT de la sesión activa
  String? get _token => ref.read(authProvider).session?.accessToken;

  /// Carga las API Keys del usuario (inicializa con datos de prueba si está vacío)
  Future<void> fetchKeys() async {
    if (state.isEmpty) {
      state = [
        AiKey(
          id: 'ai-key-001',
          name: 'App Producción',
          apiKey: 'raft_ai_9k8a7f23x1m902lp',
          createdAt: '2026-08-01 10:30',
          requestsUsed: 4250,
          requestsLimit: 10000,
          status: 'active',
        ),
        AiKey(
          id: 'ai-key-002',
          name: 'Script Bot Dev',
          apiKey: 'raft_ai_3b4c5d6e7f8g9h0i',
          createdAt: '2026-08-05 14:15',
          requestsUsed: 1200,
          requestsLimit: 10000,
          status: 'active',
        ),
      ];
    }
  }

  /// Genera una nueva API Key para el servicio de IA (Límite máximo 10 claves por usuario)
  Future<String?> addKey({required String name}) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return 'Sesión no válida o expirada.';
    }

    if (state.length >= 10) {
      return 'Has alcanzado el límite máximo de 10 API Keys activas.';
    }

    try {
      final newId = 'ai-key-${DateTime.now().millisecondsSinceEpoch}';
      final randomSuffix = DateTime.now().millisecondsSinceEpoch.toRadixString(
        36,
      );
      final newKey = AiKey(
        id: newId,
        name: name.trim(),
        apiKey: 'raft_ai_${randomSuffix}key99',
        createdAt: DateTime.now().toString().substring(0, 16),
        requestsUsed: 0,
        requestsLimit: 10000,
        status: 'active',
      );

      state = [...state, newKey];
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserAiNotifier] Error al crear API Key: $e');
      return e.toString();
    }
  }

  /// Revoca y elimina una API Key existente por su ID
  Future<String?> deleteKey(String id) async {
    try {
      state = state.where((k) => k.id != id).toList();
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserAiNotifier] Error al eliminar API Key: $e');
      return e.toString();
    }
  }
}

/// Provider global de Riverpod para las API Keys de IA
final userAiProvider = StateNotifierProvider<UserAiNotifier, List<AiKey>>((
  ref,
) {
  ref.watch(authProvider.select((s) => s.session?.user.id));
  return UserAiNotifier(ref: ref);
});
