/// ¿Qué hace?: Mapea la respuesta JSON proveniente de los endpoints /api/me/n8n del backend C#.
/// ¿De dónde trae datos?: Recibe el mapa JSON retornado por ApiClient.
/// ¿Hacia dónde va / Cómo se conecta?: Se convierte a entidades N8nServiceData para el consumo en Riverpod.
class N8nAccountDto {
  final int id;                       // Identificador único local de la cuenta en SQL Server
  final int userId;                   // Identificador del usuario propietario
  final String externalUserRef;       // Referencia externa usada por la célula n8n
  final String email;                 // Correo asociado a la cuenta de n8n
  final String? accountId;            // Identificador de cuenta devuelto por n8n
  final String status;                // Estado actual: Pending, Active, Failed, Revoked
  final String? credential;           // URL personal o credencial persistida en SQL Server
  final String? accessType;           // Tipo de acceso retornado por la célula
  final int activeWorkflowsCount;     // Conteo actual de flujos activos
  final int maxWorkflowsCount;        // Límite máximo de flujos permitidos
  final int monthlyExecutions;        // Ejecuciones acumuladas en el mes
  final int maxMonthlyExecutions;     // Límite de ejecuciones mensuales
  final DateTime createdAt;           // Fecha de creación del registro
  final DateTime? provisionedAt;      // Fecha en que la célula activó la cuenta
  final String? lastErrorMessage;     // Último mensaje de error si falló el aprovisionamiento

  N8nAccountDto({
    required this.id,
    required this.userId,
    required this.externalUserRef,
    required this.email,
    this.accountId,
    required this.status,
    this.credential,
    this.accessType,
    required this.activeWorkflowsCount,
    required this.maxWorkflowsCount,
    required this.monthlyExecutions,
    required this.maxMonthlyExecutions,
    required this.createdAt,
    this.provisionedAt,
    this.lastErrorMessage,
  });

  /// Factory constructor para deserializar el JSON de la API
  factory N8nAccountDto.fromJson(Map<String, dynamic> json) {
    return N8nAccountDto(
      id: json['id'] as int? ?? 0,
      userId: json['userId'] as int? ?? 0,
      externalUserRef: json['externalUserRef'] as String? ?? '',
      email: json['email'] as String? ?? '',
      accountId: json['accountId'] as String?,
      status: json['status'] as String? ?? 'Inactive',
      credential: json['credential'] as String?,
      accessType: json['accessType'] as String?,
      activeWorkflowsCount: json['activeWorkflowsCount'] as int? ?? 0,
      maxWorkflowsCount: json['maxWorkflowsCount'] as int? ?? 5,
      monthlyExecutions: json['monthlyExecutions'] as int? ?? 0,
      maxMonthlyExecutions: json['maxMonthlyExecutions'] as int? ?? 1000,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      provisionedAt: json['provisionedAt'] != null
          ? DateTime.parse(json['provisionedAt'] as String)
          : null,
      lastErrorMessage: json['lastErrorMessage'] as String?,
    );
  }
}

/// ¿Qué hace?: DTO con el resultado del endpoint POST /api/me/n8n/provision.
/// ¿De dónde trae datos?: Objeto "data" del ServiceResponse retornado por el backend.
/// ¿Hacia dónde va / Cómo se conecta?: Usado por N8nRemoteDataSource y UserN8nNotifier.
class N8nProvisioningResultDto {
  final bool created;                 // Indica si la cuenta fue creada en este intento (true) o ya existía (false)
  final N8nAccountDto account;        // Datos de la cuenta n8n
  final String? accessType;           // Tipo de acceso retornado por la célula
  final String? credential;           // URL directa o token de registro para el usuario

  N8nProvisioningResultDto({
    required this.created,
    required this.account,
    this.accessType,
    this.credential,
  });

  factory N8nProvisioningResultDto.fromJson(Map<String, dynamic> json) {
    return N8nProvisioningResultDto(
      created: json['created'] as bool? ?? false,
      account: N8nAccountDto.fromJson(json['account'] as Map<String, dynamic>? ?? {}),
      accessType: json['accessType'] as String?,
      credential: json['credential'] as String?,
    );
  }
}
