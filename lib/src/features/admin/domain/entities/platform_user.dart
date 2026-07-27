class PlatformUser {
  PlatformUser({
    required this.name,
    required this.email,
    required this.createdAt,
    required this.lastAccess,
    required this.instances,
    this.suspended = false,
  });

  final String name;
  final String email;
  final String createdAt;
  final String lastAccess;
  final int instances;
  bool suspended;
}
