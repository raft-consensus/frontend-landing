// ==========================================
// ¿Qué hace?: Administra el estado reactivo de registros DNS conectándose únicamente al backend real.
// ¿De dónde recibe datos?: Invoca a UserDnsRemoteDatasource y escucha authProvider.
// ¿Hacia dónde va / Cómo se conecta?: Consumido por DnsSslPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_dns_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';

/// Notificador de estado que gestiona los registros DNS de Cloudflare en la API real
class UserDnsNotifier extends StateNotifier<List<DnsRecord>> {
  UserDnsNotifier({required this.datasource, required this.ref})
    : super(const []) {
    fetchDnsRecords();
  }

  final UserDnsRemoteDatasource datasource;
  final Ref ref;

  /// Extrae el Token JWT del usuario autenticado
  String? get _token => ref.read(authProvider).session?.accessToken;

  /// Consulta la lista de registros DNS reales desde el servidor backend (GET /api/me/dns)
  Future<String?> fetchDnsRecords() async {
    final token = _token;
    if (token == null || token.isEmpty) {
      state = const [];
      return null;
    }
    try {
      final models = await datasource.getMyDnsRecords(token);
      state = models.map((m) => m.toEntity()).toList();
      return null;
    } catch (e, stackTrace) {
      debugPrint('[UserDnsNotifier] Fallo al consultar GET /api/me/dns: $e');
      debugPrint('[StackTrace] $stackTrace');
      state = const []; // Limpia la lista si falla la consulta
      return e.toString().replaceAll('ApiException: ', '');
    }
  }

  /// Aprovisiona un nuevo registro DNS tipo A en Cloudflare (POST /api/me/dns)
  Future<String?> addRecord({
    required String subdomain,
    required String targetIp,
    String? comment,
  }) async {
    final token = _token;
    if (token == null || token.isEmpty) {
      return 'Sesión no válida o expirada. Por favor inicia sesión.';
    }

    try {
      await datasource.createDnsRecord(
        subdomain: subdomain.toLowerCase().trim(),
        content: targetIp.trim(),
        comment: comment?.trim(),
        proxied: false,
        token: token,
      );
      await fetchDnsRecords();
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserDnsNotifier] Error al crear DNS en backend: $e');
      return e.toString().replaceAll('ApiException: ', '');
    }
  }

  /// Edita un subdominio DNS existente por su ID (PUT /api/me/dns/{id})
  Future<String?> updateRecord({
    required String id,
    required String subdomain,
    required String targetIp,
    String? comment,
  }) async {
    final token = _token;
    final parsedId = int.tryParse(id);

    if (token == null || token.isEmpty || parsedId == null) {
      return 'ID de registro o sesión no válida.';
    }

    try {
      await datasource.updateDnsRecord(
        id: parsedId,
        subdomain: subdomain
            .toLowerCase()
            .trim(), // <-- 3. Enviar subdomain a la fuente remota
        content: targetIp.trim(),
        comment: comment?.trim(),
        proxied: false,
        token: token,
      );
      await fetchDnsRecords();
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserDnsNotifier] Error al actualizar DNS en backend: $e');
      return e.toString().replaceAll('ApiException: ', '');
    }
  }

  /// Revoca un subdominio DNS en Cloudflare y SQL Server (DELETE /api/me/dns/{id})
  Future<String?> deleteRecord(String id) async {
    final token = _token;
    final parsedId = int.tryParse(id);

    if (token == null || token.isEmpty || parsedId == null) {
      return 'ID de registro o sesión no válida.';
    }

    try {
      await datasource.deleteDnsRecord(id: parsedId, token: token);
      await fetchDnsRecords();
      return null; // Éxito
    } catch (e) {
      debugPrint('[UserDnsNotifier] Error al eliminar DNS en backend: $e');
      return e.toString().replaceAll('ApiException: ', '');
    }
  }
}

/// Provider global de Riverpod para consultar los registros DNS del usuario
final userDnsProvider = StateNotifierProvider<UserDnsNotifier, List<DnsRecord>>(
  (ref) {
    ref.watch(authProvider.select((s) => s.session?.user.id));
    final datasource = ref.watch(userDnsRemoteDatasourceProvider);
    return UserDnsNotifier(datasource: datasource, ref: ref);
  },
);
