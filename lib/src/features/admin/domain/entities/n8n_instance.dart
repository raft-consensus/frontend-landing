/// Representa una instancia de automatización N8N provisionada para un
/// usuario dentro del clúster Raft DB.
class N8nInstance {
  N8nInstance({
    required this.name,
    required this.owner,
    required this.host,
    required this.workflows,
    required this.executions30d,
    required this.createdAt,
    this.running = true,
  });

  final String name;
  final String owner;
  final String host;
  final int workflows;
  final int executions30d;
  final String createdAt;
  bool running;
}
