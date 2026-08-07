/// ¿Qué hace?: Entidad pura de dominio que representa un registro DNS de Cloudflare y el estado de su certificado SSL.
/// ¿De dónde trae?: Recibe los datos procesados desde el backend C# / API v4 de Cloudflare (Zone coderhivex.com).
/// ¿Hacia dónde va / Cómo se conecta?: Es utilizado por UserDnsNotifier en la capa de presentacion y consumido por DnsSslPage.
class DnsRecord {
  DnsRecord({
    required this.id,
    required this.name,
    required this.fqdn,
    required this.type,
    required this.content,
    required this.ttl,
    required this.proxied,
    required this.createdAt,
    this.sslActive = true,
    this.comment,
  });

  final String
  id; // Identificador unico del registro DNS en Cloudflare (ej. 372782c01476e4d7751c1496597806ef)
  final String name; // Subdominio ingresado por el usuario (ej. midb)
  final String
  fqdn; // Nombre de dominio completo resolbible (ej. midb.coderhivex.com)
  final String type; // Tipo de registro DNS (A, CNAME, etc.)
  final String content; // Direccion IPv4 destino del servidor asignado
  final int ttl; // Tiempo de vida en segundos (1 = Automatico en Cloudflare)
  final bool
  proxied; // false desactiva el proxy CDN para permitir conexiones TCP directas de base de datos
  final String createdAt; // Fecha de creacion del registro
  final bool
  sslActive; // Estado de proteccion del certificado SSL Universal Wildcard
  final String? comment; // Comentario u observación opcional (Campo estándar de Cloudflare)
  /// Crea una copia inmutable del objeto modificando solo los campos especificados
  DnsRecord copyWith({
    String? id,
    String? name,
    String? fqdn,
    String? type,
    String? content,
    int? ttl,
    bool? proxied,
    String? createdAt,
    bool? sslActive,
    String? comment,
  }) {
    return DnsRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      fqdn: fqdn ?? this.fqdn,
      type: type ?? this.type,
      content: content ?? this.content,
      ttl: ttl ?? this.ttl,
      proxied: proxied ?? this.proxied,
      createdAt: createdAt ?? this.createdAt,
      sslActive: sslActive ?? this.sslActive,
      comment: comment ?? this.comment,
    );
  }
}
