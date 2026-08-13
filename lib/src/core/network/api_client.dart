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

  /// URL Base del backend.
  /// ¿De dónde recibe datos?: Lee la variable de entorno 'API_URL' si se pasa por consola.
  /// ¿Hacia dónde se conecta?: Por defecto a la API desplegada en producción.
  static String get baseUrl => const String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://api.raft.andrescortes.dev',
  );

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

  /// Realiza peticiones HTTP POST codificando el cuerpo a JSON y leyendo la respuesta del servidor.
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

      // Si el servidor devuelve un cuerpo no-JSON en errores HTTP (ej: 403 Forbidden o 401)
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          // Si el cuerpo no es JSON, evalúa los códigos de estado HTTP estándar
          if (response.statusCode == 403) {
            throw ApiException(
              'Acceso denegado (HTTP 403 Forbidden). La API requiere permisos de Administrador.',
              statusCode: 403,
            );
          } else if (response.statusCode == 401) {
            throw ApiException(
              'Sesión no autorizada o expirada (HTTP 401 Unauthorized).',
              statusCode: 401,
            );
          } else if (response.statusCode == 429) {
            throw ApiException(
              'Has alcanzado el límite de intentos (máximo 3 peticiones por minuto). Por favor espera un momento.',
              statusCode: 429,
            );
          }
        }
      }

      // Si el status HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error entregado por la API
      String errorMessage = responseData['message'] as String? ?? '';

      // Si message viene vacío, revisamos el mapa de errores de validación de ASP.NET (errors)
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

      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ??
            'Ocurrió un error inesperado (HTTP ${response.statusCode})';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor: $e');
    }
  }

  /// Realiza peticiones HTTP GET y retorna el mapa JSON deserializado.
  Future<Map<String, dynamic>> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _client.get(url, headers: _buildHeaders(token));

      // Intenta deserializar el cuerpo únicamente si el servidor envió contenido
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          if (response.statusCode == 403) {
            throw ApiException(
              'Acceso denegado (HTTP 403 Forbidden). Permisos insuficientes.',
              statusCode: 403,
            );
          } else if (response.statusCode == 401) {
            throw ApiException(
              'Sesión expirada o no autorizada (HTTP 401 Unauthorized).',
              statusCode: 401,
            );
          }
        }
      }

      // Si el status HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error entregado por la API
      String errorMessage = responseData['message'] as String? ?? '';
      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ??
            'Error al obtener datos del servidor (HTTP ${response.statusCode})';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor: $e');
    }
  }

  /// Realiza peticiones HTTP PUT codificando el cuerpo a JSON de forma segura.
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _client.put(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(body),
      );

      // Intenta deserializar el cuerpo únicamente si el servidor envió contenido
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          if (response.statusCode == 403) {
            throw ApiException(
              'Acceso denegado (HTTP 403 Forbidden). Permisos insuficientes.',
              statusCode: 403,
            );
          } else if (response.statusCode == 401) {
            throw ApiException(
              'Sesión expirada o no autorizada (HTTP 401 Unauthorized).',
              statusCode: 401,
            );
          }
        }
      }

      // Si el status HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error entregado por la API
      String errorMessage = responseData['message'] as String? ?? '';
      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ??
            'Error al actualizar datos en el servidor (HTTP ${response.statusCode})';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de conexión con el servidor: $e');
    }
  }

  /// Realiza peticiones HTTP DELETE de forma segura soportando respuestas sin cuerpo (HTTP 204 / 200).
  Future<Map<String, dynamic>> delete(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl$endpoint');

    try {
      final response = await _client.delete(url, headers: _buildHeaders(token));

      // Intenta deserializar el cuerpo únicamente si el servidor envió contenido
      Map<String, dynamic> responseData = {};
      if (response.body.isNotEmpty) {
        try {
          responseData = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          // Si el cuerpo no es JSON pero el status es exitoso, continúa normalmente
        }
      }

      // Si el estado HTTP es exitoso (200 - 299)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return responseData;
      }

      // Extrae el mensaje de error enviado por el servidor
      String errorMessage = responseData['message'] as String? ?? '';
      if (errorMessage.isEmpty) {
        errorMessage =
            responseData['title'] as String? ??
            'Error al eliminar el registro en el servidor';
      }

      throw ApiException(errorMessage, statusCode: response.statusCode);
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
