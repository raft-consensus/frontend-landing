class ManagedDatabase {
  ManagedDatabase({
    required this.name,
    required this.owner,
    required this.engine,
    required this.host,
    required this.storageMb,
    required this.createdAt,
    this.running = true,
  });

  final String name;
  final String owner;
  final String engine;
  final String host;
  final double storageMb;
  final String createdAt;
  bool running;
}