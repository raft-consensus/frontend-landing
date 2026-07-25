import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

/// Excepción personalizada para capturar y transportar errores devueltos por el backend.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

/// Cliente de red encargado de abstraer la comunicación HTTP REST con el servidor backend.
///
/// ¿De dónde recibe datos?: Peticiones de los DataSources remotos.
/// ¿Hacia dónde va / Dónde se conecta?: Realiza llamadas HTTP a la URL del backend ASP.NET Core.
class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// URL Base del backend. Al ser habilitado Nginx usaremos https://raft.andrescortes.dev
  static const String baseUrl = 'https://api.raft.andrescortes.dev';

  /// Construye los encabezados HTTP comunes incluyendo el Token JWT si está presente.
  Map<String, String> _buildHeaders([String? token]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  /// Realiza peticiones HTTP POST codificando el cuerpo a JSON y leyendo la respuesta.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _client.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(body),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Si el status HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error de la API (soporta respuestas estándar y errores de validación de ASP.NET)
      String errorMessage = responseData['message'] as String? ?? '';

      // Si message viene vacío, revisamos el mapa de errores de validación (errors)
      if (errorMessage.isEmpty && responseData['errors'] is Map) {
        final Map<String, dynamic> errorsMap =
            responseData['errors'] as Map<String, dynamic>;
        if (errorsMap.isNotEmpty) {
          final firstErrorList = errorsMap.values.first;
          if (firstErrorList is List && firstErrorList.isNotEmpty) {
            errorMessage = firstErrorList.first.toString();
          }
        }
      }

      // Si aún sigue vacío, intenta leer la propiedad title de ASP.NET
      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ?? 'Ocurrió un error inesperado';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
    } on FormatException {
      throw ApiException('Respuesta con formato JSON inválido del servidor');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor: $e');
    }
  }

  /// Realiza peticiones HTTP GET y retorna el mapa JSON deserializado.
  /// ¿Qué hace?: Realiza una consulta GET al endpoint indicado.
  /// ¿De dónde recibe datos?: Peticiones de los DataSources remotos (ej: MetricsRemoteDataSource).
  /// ¿Hacia dónde se conecta?: Backend ASP.NET Core.
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _client.get(url, headers: _buildHeaders(token));

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Si el status HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error entregado por la API
      String errorMessage = responseData['message'] as String? ?? '';
      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ??
            'Error al obtener datos del servidor';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
    } on FormatException {
      throw ApiException('Respuesta con formato JSON inválido del servidor');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor: $e');
    }
  }
}

/// Proveedor global de Riverpod para inyectar la instancia de ApiClient.
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
