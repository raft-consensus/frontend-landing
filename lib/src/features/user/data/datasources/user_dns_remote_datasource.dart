// ==========================================
// Archivo: lib/src/features/user/data/datasources/user_dns_remote_datasource.dart
// ¿Qué hace?: Realiza las peticiones HTTP reales hacia la API /api/me/dns usando ApiClient.
// ¿De dónde recibe datos?: Invoca a ApiClient (core/network/api_client.dart) adjuntando el Token JWT.
// ¿Hacia dónde va / Cómo se conecta?: Consumido por UserDnsNotifier en la capa de presentación.
// ==========================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/features/user/data/models/dns_record_model.dart';
import 'package:http/http.dart';

/// Fuente de datos remota encargada de consumir los endpoints de DNS del usuario en el backend C#
class UserDnsRemoteDatasource {
  UserDnsRemoteDatasource({required this.apiClient});

  final ApiClient apiClient;

  /// Obtiene la lista de registros DNS del usuario (GET /api/me/dns)
  Future<List<DnsRecordModel>> getMyDnsRecords(String token) async {
    final response = await apiClient.get('/api/me/dns', token: token);

    // Lee la lista contenida dentro de la propiedad 'data' del sobre de respuesta
    final List<dynamic> dataList = response['data'] as List<dynamic>? ?? [];

    return dataList
        .map((json) => DnsRecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Aprovisiona un nuevo subdominio DNS en Cloudflare (POST /api/me/dns)
  Future<DnsRecordModel> createDnsRecord({
    required String subdomain,
    required String content,
    String? comment,
    bool proxied = false,
    required String token,
  }) async {
    final response = await apiClient.post(
      '/api/me/dns',
      body: {
        'subdomain': subdomain,
        'content': content,
        'comment': comment,
        'proxied': proxied,
      },
      token: token,
    );

    final data = response['data'] as Map<String, dynamic>;
    final recordJson = data['record'] as Map<String, dynamic>? ?? data;
    return DnsRecordModel.fromJson(recordJson);
  }

  /// Edita un subdominio DNS existente (PUT /api/me/dns/{id})
  Future<DnsRecordModel> updateDnsRecord({
    required int id,
    String? subdomain, // <-- 1. Agregar parámetro opcional
    required String content,
    String? comment,
    bool proxied = false,
    required String token,
  }) async {
    final response = await apiClient.put(
      '/api/me/dns/$id',
      body: {
        if (subdomain != null && subdomain.isNotEmpty)
          'subdomain': subdomain, // <-- 2. Enviar en el JSON body
        'content': content,
        'comment': comment,
        'proxied': proxied,
      },
      token: token,
    );

    final data = response['data'] as Map<String, dynamic>;
    return DnsRecordModel.fromJson(data);
  }

  /// Elimina/revoca un subdominio DNS (DELETE /api/me/dns/{id})
  Future<bool> deleteDnsRecord({required int id, required String token}) async {
    final response = await apiClient.delete('/api/me/dns/$id', token: token);

    return response['success'] as bool? ?? true;
  }
}

/// Provider global de Riverpod para inyectar UserDnsRemoteDatasource
final userDnsRemoteDatasourceProvider = Provider<UserDnsRemoteDatasource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  return UserDnsRemoteDatasource(apiClient: apiClient);
});
