import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/platform_user.dart'; // Domain
import 'package:frontend_landing/src/features/admin/domain/entities/managed_database.dart'; // Domain
import 'package:frontend_landing/src/features/admin/domain/entities/audit_event.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/pages/admin_overview_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/pages/users_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/pages/admin_databases_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/pages/infrastructure_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/pages/audit_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/pages/admin_settings_page.dart'; // Page
import 'package:frontend_landing/src/features/admin/presentation/widgets/layout/admin_sidebar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/layout/admin_topbar.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/confirmation_dialog.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/database_details_dialog.dart'; // Widget

/// ¿Qué hace?: Vista contenedora principal del Panel Administrativo que administra el estado global, navegación y las 6 secciones.
/// ¿De dónde trae?: Trae las entidades de dominio, las 6 sub-páginas (pages) y los componentes de layout (sidebar y topbar).
/// ¿Hacia dónde va / Cómo se conecta?: Es la pantalla de inicio del panel administrativo, pendiente de registrarse en las rutas de la aplicación (AppRouter).
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