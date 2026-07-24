import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const RaftAdminApp());
}

// =============================================================================
// TEMA
// =============================================================================

class AppColors {
  static const navy = Color(0xFF061A3A);
  static const deepNavy = Color(0xFF020E22);
  static const blue = Color(0xFF1478E5);
  static const cyan = Color(0xFF15CEC5);
  static const green = Color(0xFF19B978);
  static const orange = Color(0xFFFFAA3D);
  static const red = Color(0xFFE95462);
  static const purple = Color(0xFF795BEF);

  static const background = Color(0xFFF3F6FA);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF14263F);
  static const muted = Color(0xFF687A91);
  static const border = Color(0xFFE0E7F0);
}

class RaftAdminApp extends StatelessWidget {
  const RaftAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raft DB Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.blue,
          primary: AppColors.navy,
          secondary: AppColors.cyan,
          surface: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: 1.6,
            ),
          ),
        ),
      ),
      home: const AdminDashboard(),
    );
  }
}

// =============================================================================
// MODELOS
// =============================================================================

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

class AuditEvent {
  const AuditEvent({
    required this.action,
    required this.actor,
    required this.resource,
    required this.ip,
    required this.date,
    required this.level,
  });

  final String action;
  final String actor;
  final String resource;
  final String ip;
  final String date;
  final AuditLevel level;
}

enum AuditLevel { info, warning, critical }

// =============================================================================
// APLICACIÓN PRINCIPAL
// =============================================================================

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedPage = 0;
  bool _maintenanceMode = false;

  final List<PlatformUser> _users = [
    PlatformUser(
      name: 'Alex Developer',
      email: 'alex@correo.com',
      createdAt: '12 Jul 2026',
      lastAccess: 'Hace 5 min',
      instances: 3,
    ),
    PlatformUser(
      name: 'María Estudiante',
      email: 'maria@universidad.edu',
      createdAt: '15 Jul 2026',
      lastAccess: 'Hace 25 min',
      instances: 2,
    ),
    PlatformUser(
      name: 'Carlos Ramírez',
      email: 'carlos@correo.com',
      createdAt: '17 Jul 2026',
      lastAccess: 'Ayer',
      instances: 1,
    ),
    PlatformUser(
      name: 'Laura Dev',
      email: 'laura@example.com',
      createdAt: '19 Jul 2026',
      lastAccess: 'Hace 2 días',
      instances: 0,
      suspended: true,
    ),
    PlatformUser(
      name: 'José Martínez',
      email: 'jose@instituto.edu',
      createdAt: '21 Jul 2026',
      lastAccess: 'Hace 1 h',
      instances: 2,
    ),
  ];

  final List<ManagedDatabase> _databases = [
    ManagedDatabase(
      name: 'proyecto-universidad',
      owner: 'Alex Developer',
      engine: 'PostgreSQL',
      host: 'pg01.raftdb.dev',
      storageMb: 182,
      createdAt: '18 Jul 2026',
    ),
    ManagedDatabase(
      name: 'api-tienda-demo',
      owner: 'Alex Developer',
      engine: 'MongoDB',
      host: 'mongo02.raftdb.dev',
      storageMb: 96,
      createdAt: '20 Jul 2026',
    ),
    ManagedDatabase(
      name: 'sistema-notas',
      owner: 'María Estudiante',
      engine: 'MySQL',
      host: 'mysql04.raftdb.dev',
      storageMb: 241,
      createdAt: '20 Jul 2026',
    ),
    ManagedDatabase(
      name: 'inventario-pruebas',
      owner: 'Carlos Ramírez',
      engine: 'SQL Server',
      host: 'sql05.raftdb.dev',
      storageMb: 310,
      createdAt: '21 Jul 2026',
      running: false,
    ),
    ManagedDatabase(
      name: 'curso-backend',
      owner: 'José Martínez',
      engine: 'PostgreSQL',
      host: 'pg07.raftdb.dev',
      storageMb: 73,
      createdAt: '22 Jul 2026',
    ),
  ];

  final List<AuditEvent> _events = const [
    AuditEvent(
      action: 'Cuenta suspendida',
      actor: 'admin@raftdb.dev',
      resource: 'laura@example.com',
      ip: '192.168.1.14',
      date: '23 Jul · 10:42',
      level: AuditLevel.warning,
    ),
    AuditEvent(
      action: 'Instancia creada',
      actor: 'jose@instituto.edu',
      resource: 'curso-backend',
      ip: '181.45.22.17',
      date: '23 Jul · 09:15',
      level: AuditLevel.info,
    ),
    AuditEvent(
      action: 'Intentos de acceso fallidos',
      actor: 'Sistema',
      resource: 'api-tienda-demo',
      ip: '45.73.12.91',
      date: '23 Jul · 08:51',
      level: AuditLevel.critical,
    ),
    AuditEvent(
      action: 'Instancia detenida',
      actor: 'admin@raftdb.dev',
      resource: 'inventario-pruebas',
      ip: '192.168.1.14',
      date: '22 Jul · 18:20',
      level: AuditLevel.warning,
    ),
    AuditEvent(
      action: 'Credenciales regeneradas',
      actor: 'alex@correo.com',
      resource: 'proyecto-universidad',
      ip: '186.32.78.21',
      date: '22 Jul · 16:03',
      level: AuditLevel.info,
    ),
  ];

  final List<String> _titles = const [
    'Resumen administrativo',
    'Usuarios',
    'Bases de datos',
    'Infraestructura',
    'Auditoría',
    'Configuración',
  ];

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: success ? AppColors.green : AppColors.navy,
        ),
      );
  }

  void _selectPage(int index) {
    setState(() => _selectedPage = index);
  }

  void _toggleUser(PlatformUser user) {
    setState(() => user.suspended = !user.suspended);

    _showMessage(
      user.suspended
          ? 'La cuenta de ${user.name} fue suspendida.'
          : 'La cuenta de ${user.name} fue reactivada.',
      success: !user.suspended,
    );
  }

  Future<void> _deleteUser(PlatformUser user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Eliminar usuario',
        message:
            '¿Deseas eliminar a ${user.name}?\n\nTambién se eliminarán sus '
            '${user.instances} instancias y todos sus datos.',
        confirmText: 'Eliminar usuario',
        dangerous: true,
      ),
    );

    if (confirmed != true) return;

    setState(() => _users.remove(user));
    _showMessage('El usuario fue eliminado.');
  }

  void _toggleDatabase(ManagedDatabase database) {
    setState(() => database.running = !database.running);

    _showMessage(
      database.running
          ? '${database.name} se está iniciando.'
          : '${database.name} fue detenida.',
      success: database.running,
    );
  }

  Future<void> _deleteDatabase(ManagedDatabase database) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Eliminar instancia',
        message:
            '¿Deseas eliminar "${database.name}" de ${database.owner}?\n\n'
            'Esta operación no se puede deshacer.',
        confirmText: 'Eliminar instancia',
        dangerous: true,
      ),
    );

    if (confirmed != true) return;

    setState(() => _databases.remove(database));
    _showMessage('La instancia fue eliminada.');
  }

  void _showDatabaseDetails(ManagedDatabase database) {
    showDialog(
      context: context,
      builder: (context) => DatabaseDetailsDialog(database: database),
    );
  }

  Widget _buildPage() {
    switch (_selectedPage) {
      case 0:
        return AdminOverviewPage(
          users: _users,
          databases: _databases,
          events: _events,
          maintenanceMode: _maintenanceMode,
          onNavigate: _selectPage,
          onMessage: _showMessage,
        );
      case 1:
        return UsersPage(
          users: _users,
          onToggle: _toggleUser,
          onDelete: _deleteUser,
          onMessage: _showMessage,
        );
      case 2:
        return AdminDatabasesPage(
          databases: _databases,
          onToggle: _toggleDatabase,
          onDelete: _deleteDatabase,
          onDetails: _showDatabaseDetails,
          onMessage: _showMessage,
        );
      case 3:
        return InfrastructurePage(
          maintenanceMode: _maintenanceMode,
          onMessage: _showMessage,
        );
      case 4:
        return AuditPage(events: _events);
      case 5:
        return AdminSettingsPage(
          maintenanceMode: _maintenanceMode,
          onMaintenanceChanged: (value) {
            setState(() => _maintenanceMode = value);

            _showMessage(
              value
                  ? 'Modo mantenimiento activado.'
                  : 'Modo mantenimiento desactivado.',
              success: !value,
            );
          },
          onMessage: _showMessage,
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 1020;

        return Scaffold(
          drawer: desktop
              ? null
              : Drawer(
                  width: 285,
                  child: AdminSidebar(
                    selectedIndex: _selectedPage,
                    maintenanceMode: _maintenanceMode,
                    onSelect: (index) {
                      Navigator.pop(context);
                      _selectPage(index);
                    },
                  ),
                ),
          body: Row(
            children: [
              if (desktop)
                SizedBox(
                  width: 270,
                  child: AdminSidebar(
                    selectedIndex: _selectedPage,
                    maintenanceMode: _maintenanceMode,
                    onSelect: _selectPage,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    AdminTopbar(
                      title: _titles[_selectedPage],
                      desktop: desktop,
                      maintenanceMode: _maintenanceMode,
                      onMessage: _showMessage,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.02, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey(_selectedPage),
                          child: _buildPage(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// SIDEBAR
// =============================================================================

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    required this.selectedIndex,
    required this.maintenanceMode,
    required this.onSelect,
    super.key,
  });

  final int selectedIndex;
  final bool maintenanceMode;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      SidebarData(Icons.dashboard_rounded, 'Resumen'),
      SidebarData(Icons.people_alt_rounded, 'Usuarios'),
      SidebarData(Icons.storage_rounded, 'Bases de datos'),
      SidebarData(Icons.dns_rounded, 'Infraestructura'),
      SidebarData(Icons.policy_rounded, 'Auditoría'),
      SidebarData(Icons.settings_rounded, 'Configuración'),
    ];

    return Container(
      color: AppColors.deepNavy,
      padding: const EdgeInsets.fromLTRB(16, 23, 16, 18),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminLogo(),
            const SizedBox(height: 34),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.purple.withOpacity(0.13),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.purple.withOpacity(0.22),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xFF9B87FF),
                    size: 21,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Panel administrativo',
                      style: TextStyle(
                        color: Color(0xFFC8BEFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'ADMINISTRACIÓN',
                style: TextStyle(
                  color: Color(0xFF68809F),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              items.length,
              (index) => AdminSidebarItem(
                data: items[index],
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
              ),
            ),
            const Spacer(),
            if (maintenanceMode)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.orange.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.orange.withOpacity(0.23),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.construction_rounded,
                      color: AppColors.orange,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mantenimiento activo',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const AdminProfile(),
          ],
        ),
      ),
    );
  }
}

class SidebarData {
  const SidebarData(this.icon, this.label);

  final IconData icon;
  final String label;
}

class AdminSidebarItem extends StatelessWidget {
  const AdminSidebarItem({
    required this.data,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SidebarData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? AppColors.blue.withOpacity(0.19)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(13),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: selected
                  ? Border.all(
                      color: AppColors.blue.withOpacity(0.22),
                    )
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  data.icon,
                  size: 21,
                  color: selected
                      ? AppColors.cyan
                      : const Color(0xFF8499B4),
                ),
                const SizedBox(width: 13),
                Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFF98AAC1),
                    fontSize: 13,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                if (selected) ...[
                  const Spacer(),
                  const CircleAvatar(
                    radius: 3,
                    backgroundColor: AppColors.cyan,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdminLogo extends StatelessWidget {
  const AdminLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        children: [
          LogoIcon(),
          SizedBox(width: 10),
          Text(
            'Raft',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 3),
          Text(
            'DB',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          Text(
            'ADMIN',
            style: TextStyle(
              color: Color(0xFF758AA6),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoIcon extends StatelessWidget {
  const LogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cyan, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.sailing_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}

class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF18375F),
          child: Text(
            'RA',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Raft Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Superadministrador',
                style: TextStyle(
                  color: Color(0xFF7F94AE),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.logout_rounded,
          color: Color(0xFF8094AD),
          size: 19,
        ),
      ],
    );
  }
}

// =============================================================================
// TOPBAR
// =============================================================================

class AdminTopbar extends StatelessWidget {
  const AdminTopbar({
    required this.title,
    required this.desktop,
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final String title;
  final bool desktop;
  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!desktop) ...[
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: desktop ? 20 : 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (maintenanceMode && desktop) ...[
              const StatusChip(
                label: 'Mantenimiento',
                color: AppColors.orange,
                icon: Icons.construction_rounded,
              ),
              const SizedBox(width: 12),
            ],
            if (desktop) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2FAF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD5EEE5),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.green,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Sistemas operativos',
                      style: TextStyle(
                        color: Color(0xFF287558),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
            Badge(
              label: const Text('4'),
              child: IconButton(
                tooltip: 'Alertas',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AdminAlertsDialog(),
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ),
            const SizedBox(width: 5),
            PopupMenuButton<String>(
              tooltip: 'Opciones administrativas',
              onSelected: (value) {
                onMessage(
                  value == 'logout'
                      ? 'Cerrando sesión administrativa...'
                      : 'Abriendo perfil administrativo...',
                );
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Perfil administrativo'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar sesión'),
                ),
              ],
              child: const CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFE0EDFB),
                child: Text(
                  'RA',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// RESUMEN
// =============================================================================

class AdminOverviewPage extends StatelessWidget {
  const AdminOverviewPage({
    required this.users,
    required this.databases,
    required this.events,
    required this.maintenanceMode,
    required this.onNavigate,
    required this.onMessage,
    super.key,
  });

  final List<PlatformUser> users;
  final List<ManagedDatabase> databases;
  final List<AuditEvent> events;
  final bool maintenanceMode;
  final ValueChanged<int> onNavigate;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final activeUsers = users.where((user) => !user.suspended).length;
    final activeDatabases =
        databases.where((database) => database.running).length;
    final totalStorage = databases.fold<double>(
      0,
      (total, database) => total + database.storageMb,
    );

    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminWelcomeBanner(
            maintenanceMode: maintenanceMode,
            onMessage: onMessage,
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1100
                  ? (width - 54) / 4
                  : width >= 620
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.people_alt_rounded,
                    color: AppColors.blue,
                    value: '${users.length}',
                    label: 'Usuarios registrados',
                    detail: '$activeUsers cuentas activas',
                    trend: '+12% este mes',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.storage_rounded,
                    color: AppColors.green,
                    value: '${databases.length}',
                    label: 'Instancias totales',
                    detail: '$activeDatabases en ejecución',
                    trend: '+8% este mes',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.data_usage_rounded,
                    color: AppColors.purple,
                    value: '${totalStorage.toStringAsFixed(0)} MB',
                    label: 'Almacenamiento',
                    detail: 'Uso global de la plataforma',
                    trend: '32% disponible',
                  ),
                  AdminMetricCard(
                    width: cardWidth,
                    icon: Icons.monitor_heart_rounded,
                    color: AppColors.orange,
                    value: '99.98%',
                    label: 'Disponibilidad',
                    detail: 'Últimos 30 días',
                    trend: 'Operación estable',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              if (!desktop) {
                return Column(
                  children: [
                    const PlatformActivityChart(),
                    const SizedBox(height: 18),
                    EngineDistributionCard(databases: databases),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                    child: PlatformActivityChart(),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: EngineDistributionCard(
                      databases: databases,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 25),
          SectionTitle(
            title: 'Estado de infraestructura',
            subtitle: 'Vista rápida de los servicios principales.',
            action: 'Ver infraestructura',
            onAction: () => onNavigate(3),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final itemWidth = width >= 900
                  ? (width - 36) / 3
                  : width >= 600
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: const [
                  ServiceStatusCard(
                    name: 'API principal',
                    detail: '38 ms de respuesta',
                    icon: Icons.api_rounded,
                    color: AppColors.blue,
                  ),
                  ServiceStatusCard(
                    name: 'Clúster de bases de datos',
                    detail: '5 nodos saludables',
                    icon: Icons.hub_rounded,
                    color: AppColors.green,
                  ),
                  ServiceStatusCard(
                    name: 'Autenticación',
                    detail: 'OAuth operativo',
                    icon: Icons.security_rounded,
                    color: AppColors.purple,
                  ),
                ]
                    .map(
                      (card) => SizedBox(
                        width: itemWidth,
                        child: card,
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 25),
          SectionTitle(
            title: 'Eventos recientes',
            subtitle: 'Actividad administrativa y de seguridad.',
            action: 'Ver auditoría',
            onAction: () => onNavigate(4),
          ),
          const SizedBox(height: 14),
          AdminCard(
            padding: const EdgeInsets.symmetric(
              horizontal: 19,
              vertical: 6,
            ),
            child: Column(
              children: events
                  .take(4)
                  .map(
                    (event) => AuditEventRow(event: event),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class AdminWelcomeBanner extends StatelessWidget {
  const AdminWelcomeBanner({
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(27),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.navy,
            Color(0xFF0A457B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 680;

          final information = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Centro de control de Raft DB',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Supervisa usuarios, instancias e infraestructura '
                'desde una única plataforma.',
                style: TextStyle(
                  color: Color(0xFFB7C9DD),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 19),
              FilledButton.icon(
                onPressed: () => onMessage(
                  'El reporte general está siendo generado.',
                  success: true,
                ),
                icon: const Icon(Icons.download_rounded),
                label: const Text('Generar reporte'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: AppColors.deepNavy,
                ),
              ),
            ],
          );

          final status = Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  maintenanceMode
                      ? Icons.construction_rounded
                      : Icons.check_circle_rounded,
                  color: maintenanceMode
                      ? AppColors.orange
                      : AppColors.cyan,
                  size: 31,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      maintenanceMode
                          ? 'Modo mantenimiento'
                          : 'Plataforma operativa',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      maintenanceMode
                          ? 'Acceso restringido'
                          : 'Sin incidentes activos',
                      style: TextStyle(
                        color: maintenanceMode
                            ? AppColors.orange
                            : AppColors.cyan,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                information,
                const SizedBox(height: 22),
                status,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: information),
              status,
            ],
          );
        },
      ),
    );
  }
}

class AdminMetricCard extends StatelessWidget {
  const AdminMetricCard({
    required this.width,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.detail,
    required this.trend,
    super.key,
  });

  final double width;
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String detail;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ColoredIcon(icon: icon, color: color),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trend,
                  style: TextStyle(
                    color: color,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            detail,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class PlatformActivityChart extends StatelessWidget {
  const PlatformActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividad de la plataforma',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Conexiones y consultas durante la última semana',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: 'Tiempo real',
                color: AppColors.green,
                icon: Icons.bolt_rounded,
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 205,
            child: CustomPaint(
              painter: AdminChartPainter(),
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChartLabel('Lun'),
              ChartLabel('Mar'),
              ChartLabel('Mié'),
              ChartLabel('Jue'),
              ChartLabel('Vie'),
              ChartLabel('Sáb'),
              ChartLabel('Dom'),
            ],
          ),
        ],
      ),
    );
  }
}

class AdminChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    const values = [0.30, 0.46, 0.41, 0.70, 0.57, 0.84, 0.76];

    final linePath = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath
          ..moveTo(x, size.height)
          ..lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blue.withOpacity(0.23),
            AppColors.blue.withOpacity(0.01),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      linePath,
      Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = Colors.white,
      );

      canvas.drawCircle(
        Offset(x, y),
        3.2,
        Paint()..color = AppColors.blue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class EngineDistributionCard extends StatelessWidget {
  const EngineDistributionCard({
    required this.databases,
    super.key,
  });

  final List<ManagedDatabase> databases;

  int count(String engine) {
    return databases.where((database) => database.engine == engine).length;
  }

  @override
  Widget build(BuildContext context) {
    final total = math.max(databases.length, 1);

    return AdminCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribución por motor',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Instancias activas y detenidas',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 23),
          EngineProgress(
            label: 'PostgreSQL',
            count: count('PostgreSQL'),
            total: total,
            color: const Color(0xFF3977A8),
          ),
          EngineProgress(
            label: 'MySQL',
            count: count('MySQL'),
            total: total,
            color: AppColors.blue,
          ),
          EngineProgress(
            label: 'MongoDB',
            count: count('MongoDB'),
            total: total,
            color: AppColors.green,
          ),
          EngineProgress(
            label: 'SQL Server',
            count: count('SQL Server'),
            total: total,
            color: AppColors.red,
          ),
        ],
      ),
    );
  }
}

class EngineProgress extends StatelessWidget {
  const EngineProgress({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    super.key,
  });

  final String label;
  final int count;
  final int total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '$count instancias',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: count / total,
              minHeight: 7,
              color: color,
              backgroundColor: color.withOpacity(0.09),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceStatusCard extends StatelessWidget {
  const ServiceStatusCard({
    required this.name,
    required this.detail,
    required this.icon,
    required this.color,
    super.key,
  });

  final String name;
  final String detail;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          ColoredIcon(icon: icon, color: color),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  detail,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const StatusChip(
            label: 'Operativo',
            color: AppColors.green,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// USUARIOS
// =============================================================================

class UsersPage extends StatefulWidget {
  const UsersPage({
    required this.users,
    required this.onToggle,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final List<PlatformUser> users;
  final ValueChanged<PlatformUser> onToggle;
  final ValueChanged<PlatformUser> onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String _query = '';
  String _status = 'Todos';

  List<PlatformUser> get filteredUsers {
    return widget.users.where((user) {
      final query = _query.toLowerCase();

      final matchesQuery =
          user.name.toLowerCase().contains(query) ||
              user.email.toLowerCase().contains(query);

      final matchesStatus = _status == 'Todos' ||
          (_status == 'Activos' && !user.suspended) ||
          (_status == 'Suspendidos' && user.suspended);

      return matchesQuery && matchesStatus;
    }).toList();
  }

  void _showUser(PlatformUser user) {
    showDialog(
      context: context,
      builder: (context) => UserDetailsDialog(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Gestión de usuarios',
            subtitle:
                'Administra las cuentas y los accesos a la plataforma.',
            action: 'Invitar usuario',
            actionIcon: Icons.person_add_alt_1_rounded,
            onAction: () => widget.onMessage(
              'Abriendo invitación de usuario...',
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar por nombre o correo...',
            selectedFilter: _status,
            filters: const ['Todos', 'Activos', 'Suspendidos'],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _status = value),
          ),
          const SizedBox(height: 18),
          if (filteredUsers.isEmpty)
            const EmptyState(
              icon: Icons.person_search_rounded,
              title: 'No encontramos usuarios',
              description: 'Prueba con otro término o filtro.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 900
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filteredUsers
                      .map(
                        (user) => UserCard(
                          width: cardWidth,
                          user: user,
                          onDetails: () => _showUser(user),
                          onToggle: () => widget.onToggle(user),
                          onDelete: () => widget.onDelete(user),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    required this.width,
    required this.user,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final double width;
  final PlatformUser user;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: user.suspended
                    ? AppColors.red.withOpacity(0.10)
                    : AppColors.blue.withOpacity(0.11),
                child: Text(
                  initials(user.name),
                  style: TextStyle(
                    color:
                        user.suspended ? AppColors.red : AppColors.blue,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      user.email,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: user.suspended ? 'Suspendido' : 'Activo',
                color:
                    user.suspended ? AppColors.red : AppColors.green,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'details') onDetails();
                  if (value == 'toggle') onToggle();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'details',
                    child: Text('Ver detalles'),
                  ),
                  PopupMenuItem(
                    value: 'toggle',
                    child: Text(
                      user.suspended
                          ? 'Reactivar cuenta'
                          : 'Suspender cuenta',
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      'Eliminar usuario',
                      style: TextStyle(color: AppColors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 19),
          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                UserInformation(
                  label: 'Instancias',
                  value: '${user.instances}',
                ),
                const VerticalDivider(width: 28),
                UserInformation(
                  label: 'Registro',
                  value: user.createdAt,
                ),
                const VerticalDivider(width: 28),
                UserInformation(
                  label: 'Último acceso',
                  value: user.lastAccess,
                ),
              ],
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.visibility_outlined, size: 18),
                  label: const Text('Ver cuenta'),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: onToggle,
                style: OutlinedButton.styleFrom(
                  foregroundColor: user.suspended
                      ? AppColors.green
                      : AppColors.orange,
                ),
                child: Text(
                  user.suspended ? 'Reactivar' : 'Suspender',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UserInformation extends StatelessWidget {
  const UserInformation({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// BASES DE DATOS
// =============================================================================

class AdminDatabasesPage extends StatefulWidget {
  const AdminDatabasesPage({
    required this.databases,
    required this.onToggle,
    required this.onDelete,
    required this.onDetails,
    required this.onMessage,
    super.key,
  });

  final List<ManagedDatabase> databases;
  final ValueChanged<ManagedDatabase> onToggle;
  final ValueChanged<ManagedDatabase> onDelete;
  final ValueChanged<ManagedDatabase> onDetails;
  final void Function(String, {bool success}) onMessage;

  @override
  State<AdminDatabasesPage> createState() => _AdminDatabasesPageState();
}

class _AdminDatabasesPageState extends State<AdminDatabasesPage> {
  String _query = '';
  String _engine = 'Todos';

  List<ManagedDatabase> get filtered {
    return widget.databases.where((database) {
      final query = _query.toLowerCase();

      return (database.name.toLowerCase().contains(query) ||
              database.owner.toLowerCase().contains(query)) &&
          (_engine == 'Todos' || database.engine == _engine);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Bases de datos de la plataforma',
            subtitle:
                'Supervisa todas las instancias creadas por los usuarios.',
            action: 'Exportar listado',
            actionIcon: Icons.download_rounded,
            onAction: () => widget.onMessage(
              'El listado se está exportando.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar instancia o propietario...',
            selectedFilter: _engine,
            filters: const [
              'Todos',
              'MySQL',
              'PostgreSQL',
              'SQL Server',
              'MongoDB',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _engine = value),
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            const EmptyState(
              icon: Icons.storage_rounded,
              title: 'No encontramos instancias',
              description: 'Prueba con otro filtro o término de búsqueda.',
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth >= 950
                    ? (constraints.maxWidth - 18) / 2
                    : constraints.maxWidth;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filtered
                      .map(
                        (database) => ManagedDatabaseCard(
                          width: cardWidth,
                          database: database,
                          onDetails: () =>
                              widget.onDetails(database),
                          onToggle: () => widget.onToggle(database),
                          onDelete: () => widget.onDelete(database),
                          onRestart: () => widget.onMessage(
                            '${database.name} se está reiniciando.',
                            success: true,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ManagedDatabaseCard extends StatelessWidget {
  const ManagedDatabaseCard({
    required this.width,
    required this.database,
    required this.onDetails,
    required this.onToggle,
    required this.onDelete,
    required this.onRestart,
    super.key,
  });

  final double width;
  final ManagedDatabase database;
  final VoidCallback onDetails;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(database.engine);

    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              ColoredIcon(icon: style.icon, color: style.color),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      database.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${database.engine} · ${database.host}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: database.running ? 'Activa' : 'Detenida',
                color: database.running
                    ? AppColors.green
                    : AppColors.muted,
              ),
            ],
          ),
          const SizedBox(height: 19),
          InformationRow(
            icon: Icons.person_outline_rounded,
            label: 'Propietario',
            value: database.owner,
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.data_usage_rounded,
            label: 'Almacenamiento',
            value: '${database.storageMb.toStringAsFixed(0)} MB',
          ),
          const SizedBox(height: 10),
          InformationRow(
            icon: Icons.calendar_today_outlined,
            label: 'Creada',
            value: database.createdAt,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.visibility_outlined, size: 17),
                  label: const Text('Inspeccionar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              IconButton.outlined(
                tooltip: 'Reiniciar',
                onPressed: onRestart,
                icon: const Icon(Icons.restart_alt_rounded),
              ),
              const SizedBox(width: 7),
              IconButton.outlined(
                tooltip: database.running ? 'Detener' : 'Iniciar',
                onPressed: onToggle,
                icon: Icon(
                  database.running
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_rounded,
                ),
              ),
              const SizedBox(width: 7),
              IconButton.outlined(
                tooltip: 'Eliminar',
                onPressed: onDelete,
                style: IconButton.styleFrom(
                  foregroundColor: AppColors.red,
                ),
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// INFRAESTRUCTURA
// =============================================================================

class InfrastructurePage extends StatelessWidget {
  const InfrastructurePage({
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    const nodes = [
      NodeData(
        'raft-node-01',
        'Base de datos',
        '12%',
        '38%',
        '1.4 GB',
        AppColors.green,
      ),
      NodeData(
        'raft-node-02',
        'Base de datos',
        '28%',
        '54%',
        '2.1 GB',
        AppColors.green,
      ),
      NodeData(
        'raft-node-03',
        'API y autenticación',
        '44%',
        '61%',
        '1.8 GB',
        AppColors.orange,
      ),
      NodeData(
        'raft-backup-01',
        'Copias de seguridad',
        '8%',
        '24%',
        '8.6 GB',
        AppColors.green,
      ),
    ];

    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: 'Infraestructura',
            subtitle:
                'Supervisa los nodos, recursos y servicios internos.',
            action: 'Actualizar métricas',
            actionIcon: Icons.refresh_rounded,
            onAction: () => onMessage(
              'Las métricas fueron actualizadas.',
              success: true,
            ),
          ),
          const SizedBox(height: 20),
          if (maintenanceMode) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7E7),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: const Color(0xFFFFDF9D),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.construction_rounded,
                    color: AppColors.orange,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'El modo mantenimiento está activo. Los usuarios '
                      'tienen acceso restringido a la plataforma.',
                      style: TextStyle(
                        color: Color(0xFF74531D),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1000
                  ? (width - 54) / 4
                  : width >= 600
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'CPU promedio',
                    value: '23%',
                    icon: Icons.memory_rounded,
                    color: AppColors.blue,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Memoria utilizada',
                    value: '47%',
                    icon: Icons.developer_board_rounded,
                    color: AppColors.purple,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Disco utilizado',
                    value: '4.2 TB',
                    icon: Icons.circle_rounded,
                    color: AppColors.orange,
                  ),
                  InfrastructureMetric(
                    width: cardWidth,
                    label: 'Tráfico actual',
                    value: '82 MB/s',
                    icon: Icons.swap_vert_rounded,
                    color: AppColors.cyan,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 25),
          const SectionTitle(
            title: 'Nodos de la plataforma',
            subtitle: 'Recursos y estado actual de cada servidor.',
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth >= 900
                  ? (constraints.maxWidth - 18) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: nodes
                    .map(
                      (node) => NodeCard(
                        width: cardWidth,
                        data: node,
                        onRestart: () => onMessage(
                          '${node.name} se está reiniciando.',
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class InfrastructureMetric extends StatelessWidget {
  const InfrastructureMetric({
    required this.width,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    super.key,
  });

  final double width;
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(19),
      child: Row(
        children: [
          ColoredIcon(icon: icon, color: color),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NodeData {
  const NodeData(
    this.name,
    this.role,
    this.cpu,
    this.memory,
    this.disk,
    this.statusColor,
  );

  final String name;
  final String role;
  final String cpu;
  final String memory;
  final String disk;
  final Color statusColor;
}

class NodeCard extends StatelessWidget {
  const NodeCard({
    required this.width,
    required this.data,
    required this.onRestart,
    super.key,
  });

  final double width;
  final NodeData data;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              ColoredIcon(
                icon: Icons.dns_rounded,
                color: AppColors.blue,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      data.role,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              StatusChip(
                label: 'Saludable',
                color: data.statusColor,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              NodeMetric(label: 'CPU', value: data.cpu),
              NodeMetric(label: 'Memoria', value: data.memory),
              NodeMetric(label: 'Disco', value: data.disk),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onRestart,
              icon: const Icon(Icons.restart_alt_rounded, size: 18),
              label: const Text('Reiniciar nodo'),
            ),
          ),
        ],
      ),
    );
  }
}

class NodeMetric extends StatelessWidget {
  const NodeMetric({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// AUDITORÍA
// =============================================================================

class AuditPage extends StatefulWidget {
  const AuditPage({
    required this.events,
    super.key,
  });

  final List<AuditEvent> events;

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  String _query = '';
  String _level = 'Todos';

  List<AuditEvent> get filtered {
    return widget.events.where((event) {
      final query = _query.toLowerCase();

      final matchesQuery =
          event.action.toLowerCase().contains(query) ||
              event.actor.toLowerCase().contains(query) ||
              event.resource.toLowerCase().contains(query);

      final matchesLevel = _level == 'Todos' ||
          (_level == 'Información' &&
              event.level == AuditLevel.info) ||
          (_level == 'Advertencias' &&
              event.level == AuditLevel.warning) ||
          (_level == 'Críticos' &&
              event.level == AuditLevel.critical);

      return matchesQuery && matchesLevel;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Registro de auditoría',
            subtitle:
                'Consulta acciones administrativas y eventos de seguridad.',
          ),
          const SizedBox(height: 20),
          FilterBar(
            hint: 'Buscar acción, usuario o recurso...',
            selectedFilter: _level,
            filters: const [
              'Todos',
              'Información',
              'Advertencias',
              'Críticos',
            ],
            onSearch: (value) => setState(() => _query = value),
            onFilter: (value) => setState(() => _level = value),
          ),
          const SizedBox(height: 18),
          AdminCard(
            padding: const EdgeInsets.all(0),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(35),
                    child: EmptyStateContent(
                      icon: Icons.policy_rounded,
                      title: 'No encontramos eventos',
                      description: 'Modifica los filtros de búsqueda.',
                    ),
                  )
                : Column(
                    children: filtered
                        .map((event) => AuditEventRow(event: event))
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class AuditEventRow extends StatelessWidget {
  const AuditEventRow({
    required this.event,
    super.key,
  });

  final AuditEvent event;

  @override
  Widget build(BuildContext context) {
    final style = auditStyle(event.level);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final main = Row(
            children: [
              CircleAvatar(
                radius: 19,
                backgroundColor: style.color.withOpacity(0.10),
                child: Icon(
                  style.icon,
                  color: style.color,
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.action,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${event.actor} · ${event.resource}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final details = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatusChip(
                label: style.label,
                color: style.color,
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    event.date,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    event.ip,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          );

          if (compact) {
            return Column(
              children: [
                main,
                const SizedBox(height: 13),
                Align(
                  alignment: Alignment.centerRight,
                  child: details,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: main),
              details,
            ],
          );
        },
      ),
    );
  }
}

class AuditStyle {
  const AuditStyle(this.label, this.color, this.icon);

  final String label;
  final Color color;
  final IconData icon;
}

AuditStyle auditStyle(AuditLevel level) {
  switch (level) {
    case AuditLevel.info:
      return const AuditStyle(
        'Información',
        AppColors.blue,
        Icons.info_outline_rounded,
      );
    case AuditLevel.warning:
      return const AuditStyle(
        'Advertencia',
        AppColors.orange,
        Icons.warning_amber_rounded,
      );
    case AuditLevel.critical:
      return const AuditStyle(
        'Crítico',
        AppColors.red,
        Icons.error_outline_rounded,
      );
  }
}

// =============================================================================
// CONFIGURACIÓN
// =============================================================================

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({
    required this.maintenanceMode,
    required this.onMaintenanceChanged,
    required this.onMessage,
    super.key,
  });

  final bool maintenanceMode;
  final ValueChanged<bool> onMaintenanceChanged;
  final void Function(String, {bool success}) onMessage;

  @override
  State<AdminSettingsPage> createState() =>
      _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  double _maxInstances = 5;
  double _storageMb = 512;
  double _inactivityDays = 7;

  bool _allowRegistrations = true;
  bool _googleLogin = true;
  bool _githubLogin = true;
  bool _automaticBackups = true;

  @override
  Widget build(BuildContext context) {
    return AdminScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            title: 'Configuración de la plataforma',
            subtitle:
                'Define límites, accesos y comportamiento global de Raft DB.',
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              final limits = AdminCard(
                padding: const EdgeInsets.all(23),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsHeader(
                      icon: Icons.tune_rounded,
                      title: 'Límites del plan gratuito',
                      description:
                          'Restricciones aplicadas a cada usuario.',
                    ),
                    const SizedBox(height: 23),
                    LimitSlider(
                      label: 'Instancias por usuario',
                      value: _maxInstances,
                      min: 1,
                      max: 10,
                      displayValue: '${_maxInstances.round()}',
                      onChanged: (value) {
                        setState(() => _maxInstances = value);
                      },
                    ),
                    LimitSlider(
                      label: 'Almacenamiento por instancia',
                      value: _storageMb,
                      min: 128,
                      max: 2048,
                      divisions: 15,
                      displayValue: '${_storageMb.round()} MB',
                      onChanged: (value) {
                        setState(() => _storageMb = value);
                      },
                    ),
                    LimitSlider(
                      label: 'Días antes de suspender por inactividad',
                      value: _inactivityDays,
                      min: 1,
                      max: 30,
                      displayValue: '${_inactivityDays.round()} días',
                      onChanged: (value) {
                        setState(() => _inactivityDays = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.onMessage(
                          'Los límites fueron actualizados.',
                          success: true,
                        ),
                        child: const Text('Guardar límites'),
                      ),
                    ),
                  ],
                ),
              );

              final access = Column(
                children: [
                  AdminCard(
                    padding: const EdgeInsets.all(23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsHeader(
                          icon: Icons.login_rounded,
                          title: 'Registro y autenticación',
                          description:
                              'Métodos disponibles para acceder.',
                        ),
                        const SizedBox(height: 12),
                        SettingSwitch(
                          title: 'Permitir nuevos registros',
                          subtitle:
                              'Los visitantes pueden crear una cuenta.',
                          value: _allowRegistrations,
                          onChanged: (value) {
                            setState(() => _allowRegistrations = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Inicio de sesión con Google',
                          subtitle: 'OAuth mediante cuentas de Google.',
                          value: _googleLogin,
                          onChanged: (value) {
                            setState(() => _googleLogin = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Inicio de sesión con GitHub',
                          subtitle: 'OAuth mediante cuentas de GitHub.',
                          value: _githubLogin,
                          onChanged: (value) {
                            setState(() => _githubLogin = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  AdminCard(
                    padding: const EdgeInsets.all(23),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsHeader(
                          icon: Icons.cloud_sync_rounded,
                          title: 'Operación y mantenimiento',
                          description:
                              'Controles críticos de la plataforma.',
                        ),
                        const SizedBox(height: 12),
                        SettingSwitch(
                          title: 'Copias de seguridad automáticas',
                          subtitle: 'Respaldo diario de las instancias.',
                          value: _automaticBackups,
                          onChanged: (value) {
                            setState(() => _automaticBackups = value);
                          },
                        ),
                        SettingSwitch(
                          title: 'Modo mantenimiento',
                          subtitle:
                              'Restringe temporalmente el acceso de usuarios.',
                          value: widget.maintenanceMode,
                          dangerous: true,
                          onChanged: widget.onMaintenanceChanged,
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (!desktop) {
                return Column(
                  children: [
                    limits,
                    const SizedBox(height: 18),
                    access,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: limits),
                  const SizedBox(width: 18),
                  Expanded(child: access),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          AdminCard(
            padding: const EdgeInsets.all(23),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SettingsHeader(
                  icon: Icons.warning_amber_rounded,
                  title: 'Zona de peligro',
                  description:
                      'Acciones críticas que afectan toda la plataforma.',
                  color: AppColors.red,
                ),
                const SizedBox(height: 20),
                DangerAction(
                  title: 'Detener todas las instancias',
                  description:
                      'Apaga temporalmente todas las bases de datos.',
                  buttonText: 'Detener instancias',
                  onPressed: () => widget.onMessage(
                    'Esta acción requiere confirmación adicional.',
                  ),
                ),
                const Divider(height: 30),
                DangerAction(
                  title: 'Limpiar datos temporales',
                  description:
                      'Elimina caché, archivos temporales y registros antiguos.',
                  buttonText: 'Limpiar datos',
                  onPressed: () => widget.onMessage(
                    'Los datos temporales fueron eliminados.',
                    success: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    required this.icon,
    required this.title,
    required this.description,
    this.color = AppColors.blue,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColoredIcon(icon: icon, color: color),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LimitSlider extends StatelessWidget {
  const LimitSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
    this.divisions,
    super.key,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                displayValue,
                style: const TextStyle(
                  color: AppColors.blue,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions ?? (max - min).round(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.dangerous = false,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final bool dangerous;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      activeColor: dangerous ? AppColors.red : AppColors.blue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          color: dangerous ? AppColors.red : AppColors.text,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 10,
        ),
      ),
    );
  }
}

class DangerAction extends StatelessWidget {
  const DangerAction({
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 600;

        final information = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 10,
              ),
            ),
          ],
        );

        final button = OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.red,
            side: const BorderSide(color: AppColors.red),
          ),
          child: Text(buttonText),
        );

        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              information,
              const SizedBox(height: 13),
              button,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: information),
            button,
          ],
        );
      },
    );
  }
}

// =============================================================================
// DIÁLOGOS
// =============================================================================

class UserDetailsDialog extends StatelessWidget {
  const UserDetailsDialog({
    required this.user,
    super.key,
  });

  final PlatformUser user;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.blue.withOpacity(0.10),
                    child: Text(
                      initials(user.name),
                      style: const TextStyle(
                        color: AppColors.blue,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              DialogInformation(
                label: 'Estado',
                value: user.suspended ? 'Suspendido' : 'Activo',
              ),
              DialogInformation(
                label: 'Fecha de registro',
                value: user.createdAt,
              ),
              DialogInformation(
                label: 'Último acceso',
                value: user.lastAccess,
              ),
              DialogInformation(
                label: 'Instancias',
                value: '${user.instances}',
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DatabaseDetailsDialog extends StatelessWidget {
  const DatabaseDetailsDialog({
    required this.database,
    super.key,
  });

  final ManagedDatabase database;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(database.engine);

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540),
        child: Padding(
          padding: const EdgeInsets.all(27),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ColoredIcon(icon: style.icon, color: style.color),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          database.name,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          database.engine,
                          style: TextStyle(
                            color: style.color,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              DialogInformation(
                label: 'Propietario',
                value: database.owner,
              ),
              DialogInformation(
                label: 'Host',
                value: database.host,
              ),
              DialogInformation(
                label: 'Almacenamiento',
                value: '${database.storageMb.toStringAsFixed(0)} MB',
              ),
              DialogInformation(
                label: 'Fecha de creación',
                value: database.createdAt,
              ),
              DialogInformation(
                label: 'Estado',
                value: database.running ? 'En ejecución' : 'Detenida',
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7E8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.security_rounded,
                      color: AppColors.orange,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Las credenciales completas están protegidas y '
                        'no se muestran en el panel administrativo.',
                        style: TextStyle(
                          color: Color(0xFF76561F),
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    required this.title,
    required this.message,
    required this.confirmText,
    this.dangerous = false,
    super.key,
  });

  final String title;
  final String message;
  final String confirmText;
  final bool dangerous;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(
        dangerous
            ? Icons.warning_amber_rounded
            : Icons.help_outline_rounded,
        color: dangerous ? AppColors.red : AppColors.blue,
        size: 38,
      ),
      title: Text(title),
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          style: FilledButton.styleFrom(
            backgroundColor:
                dangerous ? AppColors.red : AppColors.navy,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}

class AdminAlertsDialog extends StatelessWidget {
  const AdminAlertsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 9),
          Text('Alertas administrativas'),
        ],
      ),
      content: const SizedBox(
        width: 430,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AlertItem(
              color: AppColors.red,
              title: 'Intentos de acceso sospechosos',
              description: '5 intentos desde la IP 45.73.12.91.',
            ),
            Divider(),
            AlertItem(
              color: AppColors.orange,
              title: 'Nodo con carga elevada',
              description: 'raft-node-03 alcanzó 78% de CPU.',
            ),
            Divider(),
            AlertItem(
              color: AppColors.blue,
              title: 'Nuevo usuario registrado',
              description: 'jose@instituto.edu creó una cuenta.',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}

class AlertItem extends StatelessWidget {
  const AlertItem({
    required this.color,
    required this.title,
    required this.description,
    super.key,
  });

  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.10),
            child: Icon(
              Icons.notifications_active_outlined,
              color: color,
              size: 18,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DialogInformation extends StatelessWidget {
  const DialogInformation({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// COMPONENTES COMPARTIDOS
// =============================================================================

class AdminScrollView extends StatelessWidget {
  const AdminScrollView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: child,
        ),
      ),
    );
  }
}

class AdminCard extends StatelessWidget {
  const AdminCard({
    required this.child,
    this.width,
    this.padding = const EdgeInsets.all(20),
    super.key,
  });

  final Widget child;
  final double? width;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    required this.subtitle,
    this.action,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? action;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (action != null && onAction != null)
          actionIcon == null
              ? TextButton(
                  onPressed: onAction,
                  child: Text(action!),
                )
              : FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 17),
                  label: Text(action!),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
      ],
    );
  }
}

class FilterBar extends StatelessWidget {
  const FilterBar({
    required this.hint,
    required this.selectedFilter,
    required this.filters,
    required this.onSearch,
    required this.onFilter,
    super.key,
  });

  final String hint;
  final String selectedFilter;
  final List<String> filters;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onFilter;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: const EdgeInsets.all(15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 620;

          final search = TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded),
            ),
          );

          final filter = DropdownButtonFormField<String>(
            value: selectedFilter,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.filter_list_rounded),
            ),
            items: filters
                .map(
                  (filter) => DropdownMenuItem(
                    value: filter,
                    child: Text(filter),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) onFilter(value);
            },
          );

          if (compact) {
            return Column(
              children: [
                search,
                const SizedBox(height: 12),
                filter,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: search),
              const SizedBox(width: 13),
              SizedBox(width: 210, child: filter),
            ],
          );
        },
      ),
    );
  }
}

class ColoredIcon extends StatelessWidget {
  const ColoredIcon({
    required this.icon,
    required this.color,
    super.key,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 47,
      height: 47,
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    required this.label,
    required this.color,
    this.icon,
    super.key,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
          ] else ...[
            CircleAvatar(radius: 3, backgroundColor: color),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class InformationRow extends StatelessWidget {
  const InformationRow({
    required this.icon,
    required this.label,
    required this.value,
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.muted, size: 17),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 55),
      child: EmptyStateContent(
        icon: icon,
        title: title,
        description: description,
      ),
    );
  }
}

class EmptyStateContent extends StatelessWidget {
  const EmptyStateContent({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 33,
          backgroundColor: AppColors.blue.withOpacity(0.10),
          child: Icon(icon, color: AppColors.blue, size: 31),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 17,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class ChartLabel extends StatelessWidget {
  const ChartLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 9,
      ),
    );
  }
}

class EngineStyle {
  const EngineStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}

EngineStyle engineStyle(String engine) {
  switch (engine) {
    case 'PostgreSQL':
      return const EngineStyle(
        Icons.storage_rounded,
        Color(0xFF3977A8),
      );
    case 'MySQL':
      return const EngineStyle(
        Icons.dns_rounded,
        AppColors.blue,
      );
    case 'MongoDB':
      return const EngineStyle(
        Icons.eco_rounded,
        AppColors.green,
      );
    case 'SQL Server':
      return const EngineStyle(
        Icons.table_chart_rounded,
        AppColors.red,
      );
    default:
      return const EngineStyle(
        Icons.storage_rounded,
        AppColors.muted,
      );
  }
}

String initials(String name) {
  final parts = name
      .trim()
      .split(' ')
      .where((part) => part.isNotEmpty)
      .toList();

  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts.first[0].toUpperCase();

  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
}