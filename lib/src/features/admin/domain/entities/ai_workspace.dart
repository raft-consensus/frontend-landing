/// Representa un espacio de trabajo de IA provisionado para un usuario
/// (acceso a modelos de lenguaje / inferencia dentro del clúster Raft DB).
class AiWorkspace {
  AiWorkspace({
    required this.name,
    required this.owner,
    required this.provider,
    required this.model,
    required this.requestsUsed,
    required this.requestsLimit,
    required this.createdAt,
    this.active = true,
  });

  final String name;
  final String owner;
  final String provider;
  final String model;
  final int requestsUsed;
  final int requestsLimit;
  final String createdAt;
  bool active;

  double get usageRatio =>
      requestsLimit == 0 ? 0 : requestsUsed / requestsLimit;
}
