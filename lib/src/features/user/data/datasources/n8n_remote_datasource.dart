import 'package:frontend_landing/src/core/network/api_client.dart';
import 'package:frontend_landing/src/core/network/session_storage.dart';
import 'package:frontend_landing/src/features/user/data/models/n8n_account_dto.dart';

/// ¿Qué hace?: Fuente de datos remota encargada de realizar las peticiones HTTP relativas a n8n contra la API de C# .NET.
/// ¿De dónde trae datos?: Consume la API .NET mediante la instancia inyectada de ApiClient y lee el JWT desde SessionStorage.
/// ¿Hacia dónde va / Cómo se conecta?: Es invocado por los notifiers/providers de Riverpod en user_n8n_provider.dart.
class N8nRemoteDataSource {
  final ApiClient _apiClient;           // Cliente HTTP centralizado
  final SessionStorage _sessionStorage; // Almacenamiento local del token JWT

  N8nRemoteDataSource(this._apiClient, this._sessionStorage);

  /// Obtiene la lista de cuentas n8n del usuario autenticado desde GET /api/me/n8n
  Future<List<N8nAccountDto>> getMyAccounts() async {
    final token = await _sessionStorage.getToken();
    final response = await _apiClient.get('/api/me/n8n', token: token);
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((json) => N8nAccountDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  /// Solicita el aprovisionamiento de n8n para el usuario mediante POST /api/me/n8n/provision
  Future<N8nProvisioningResultDto> provisionAccount() async {
    final token = await _sessionStorage.getToken();
    // Se pasa body: {} requerido por la firma de ApiClient.post
    final response = await _apiClient.post(
      '/api/me/n8n/provision',
      body: {},
      token: token,
    );
    final data = response['data'] as Map<String, dynamic>;
    return N8nProvisioningResultDto.fromJson(data);
  }
}
