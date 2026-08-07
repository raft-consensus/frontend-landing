// ==========================================
// Archivo: lib/src/features/user/data/models/dns_record_model.dart
// ¿Qué hace?: Deserializa las respuestas JSON del backend ASP.NET Core (/api/me/dns) en entidades DnsRecord.
// ¿De dónde recibe datos?: Deserializa las respuestas de DnsController en el backend.
// ¿Hacia dónde va / Cómo se conecta?: Consumido por UserDnsRemoteDatasource y UserDnsNotifier.
// ==========================================

import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';

/// Modelo DTO para deserializar registros DNS desde el backend C#
class DnsRecordModel {
  DnsRecordModel({
    required this.id,
    required this.subdomain,
    required this.fqdn,
    required this.recordType,
    required this.content,
    required this.proxied,
    required this.status,
    required this.createdAt,
    this.comment,
  });

  final int id;
  final String subdomain;
  final String fqdn;
  final String recordType;
  final String content;
  final bool proxied;
  final String status;
  final String createdAt;
  final String? comment;

  /// Factory constructor para deserializar el JSON retornado por /api/me/dns
  factory DnsRecordModel.fromJson(Map<String, dynamic> json) {
    return DnsRecordModel(
      id: json['id'] as int? ?? 0,
      subdomain: json['subdomain'] as String? ?? json['label'] as String? ?? '',
      fqdn: json['fqdn'] as String? ?? '',
      recordType: json['recordType'] as String? ?? 'A',
      content: json['content'] as String? ?? '',
      proxied: json['proxied'] as bool? ?? false,
      status: json['status'] as String? ?? 'Active',
      createdAt: json['createdAt'] as String? ?? '',
      comment: json['comment'] as String?,
    );
  }

  /// Convierte el modelo DTO a la entidad inmutable de dominio DnsRecord
  DnsRecord toEntity() {
    final cleanFqdn = fqdn.isNotEmpty
        ? fqdn
        : (subdomain.endsWith('.coderhivex.com')
            ? subdomain
            : '$subdomain.coderhivex.com');

    return DnsRecord(
      id: id.toString(),
      name: subdomain,
      fqdn: cleanFqdn,
      type: recordType,
      content: content,
      ttl: 1,
      proxied: proxied,
      createdAt: createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt,
      sslActive: status.toLowerCase() == 'active',
      comment: comment,
    );
  }
}
