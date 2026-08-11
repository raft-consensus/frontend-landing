// ==========================================
// Qué hace: Mapea la respuesta JSON de los endpoints /api/me/ai-keys hacia la entidad AiKey.
// Dónde se conecta: Utilizado por UserAiRemoteDatasource.
// De dónde recibe datos: Deserializa las respuestas JSON del servidor C#.
// ==========================================

import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart';

/// Modelo de datos para deserializar API Keys devueltas por el servidor C#
class AiKeyModel {
  AiKeyModel({
    required this.id,
    required this.name,
    required this.keyPrefix,
    required this.status,
    required this.createdAt,
    required this.totalRequests,
    required this.totalPromptTokens,
    required this.totalCompletionTokens,
    required this.totalTokens,
    required this.approxCostUsd,
    this.lastUsedAt,
  });

  final String id; // ID de la clave en SQL Server
  final String name; // Nombre asignado por el usuario
  final String keyPrefix; // Prefijo público de la clave
  final String status; // Estado reportado ("Active", "Revoked")
  final String createdAt; // Fecha ISO8601 de creación
  final int totalRequests; // Peticiones acumuladas
  final int totalPromptTokens; // Tokens de entrada acumulados
  final int totalCompletionTokens; // Tokens de salida acumulados
  final int totalTokens; // Tokens totales acumulados
  final double approxCostUsd; // Costo acumulado estimado
  final String? lastUsedAt; // Fecha del último uso

  /// Factory constructor robusto para mapear el JSON devuelto por C# (AiApiKeyReadDto)
  factory AiKeyModel.fromJson(Map<String, dynamic> json) {
    // Parsea de forma segura el ID soportando valores numéricos o cadenas del backend
    final rawId = json['id'] ?? json['keyId'] ?? json['aiApiKeyId'];
    final parsedId = rawId?.toString() ?? '';

    return AiKeyModel(
      id: parsedId,
      name: json['name'] as String? ?? '',
      keyPrefix: json['keyPrefix'] as String? ?? '',
      status: json['status'] as String? ?? 'Active',
      createdAt: json['createdAt'] as String? ?? '',
      totalRequests: (json['totalRequests'] as num?)?.toInt() ?? 0,
      totalPromptTokens: (json['totalPromptTokens'] as num?)?.toInt() ?? 0,
      totalCompletionTokens:
          (json['totalCompletionTokens'] as num?)?.toInt() ?? 0,
      totalTokens: (json['totalTokens'] as num?)?.toInt() ?? 0,
      approxCostUsd: (json['approxCostUsd'] as num?)?.toDouble() ?? 0.0,
      lastUsedAt: json['lastUsedAt'] as String?,
    );
  }

  /// Convierte el modelo HTTP en la entidad limpia de dominio AiKey
  AiKey toEntity() {
    return AiKey(
      id: id,
      name: name,
      keyPrefix: keyPrefix,
      status: status,
      createdAt: createdAt.length >= 10
          ? createdAt.substring(0, 10)
          : createdAt,
      totalRequests: totalRequests,
      totalPromptTokens: totalPromptTokens,
      totalCompletionTokens: totalCompletionTokens,
      totalTokens: totalTokens,
      approxCostUsd: approxCostUsd,
      lastUsedAt: lastUsedAt != null && lastUsedAt!.length >= 16
          ? lastUsedAt!.substring(0, 16).replaceAll('T', ' ')
          : lastUsedAt,
    );
  }
}
