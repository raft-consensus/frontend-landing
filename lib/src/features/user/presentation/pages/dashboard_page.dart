import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/pages/account_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/databases_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/documentation_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/overview_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/tools_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/create_database_dialog.dart'; // Dialogs
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/dashboard_sidebar.dart'; // Layout
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/dashboard_topbar.dart'; // Layout

/// ¿Qué hace?: Vista contenedora principal del Portal de Usuario que administra el estado global, navegación y las 5 pestañas.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), componentes de layout, dialogs y las 5 sub-páginas (pages).
/// ¿Hacia dónde va / Cómo se conecta?: Es la pantalla de inicio principal del panel de usuario registrada en las rutas de la aplicación.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // 0: Resumen, 1: BD, 2: Herramientas, 3: Docs, 4: Cuenta

  // Lista inicial de instancias de prueba de bases de datos del usuario
  final List<DatabaseInstance> _instances = [
    const DatabaseInstance(
      id: 'db-101',
      name: 'api-tienda-demo',
      engine: 'PostgreSQL',
      version: '16',
      database: 'tienda_db',
      username: 'raft_user_84',
      host: 'postgresql84.raftdb.dev',
      port: 5432,
      storageUsed: 148,
      storageLimit: 512,
      createdAt: '18 Jul 2026',
      isRunning: true,
    ),
    const DatabaseInstance(
      id: 'db-102',
      name: 'blog-universidad',
      engine: 'MySQL',
      version: '8.0',
      database: 'blog_db',
      username: 'raft_user_12',
      host: 'mysql12.raftdb.dev',
      port: 3306,
      storageUsed: 92,
      storageLimit: 512,
      createdAt: '20 Jul 2026',
      isRunning: true,
    ),
    const DatabaseInstance(
      id: 'db-103',
      name: 'practica-consultas',
      engine: 'MongoDB',
      version: '7.0',
      database: 'practica_db',
      username: 'raft_user_44',
      host: 'mongodb44.raftdb.dev',
      port: 27017,
      storageUsed: 86,
      storageLimit: 512,
      createdAt: '22 Jul 2026',
      isRunning: false,
    ),
  ];

  // Mostrador de notificaciones flotantes de retroalimentación
  void _showMessage(String message, {bool success = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: success ? AppColors.navy : AppColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Abre el modal de creación de BD
  Future<void> _openCreateDatabaseDialog() async {
    final result = await showDialog<DatabaseInstance>(
      context: context,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (result != null) {
      setState(() => _instances.insert(0, result));
      _showMessage('Instancia "${result.name}" creada con éxito.');
    }
  }

  // Alternar estado encendido/apagado de una BD
  void _toggleInstanceState(int index) {
    setState(() {
      final current = _instances[index];
      _instances[index] = current.copyWith(isRunning: !current.isRunning);
    });
    final instance = _instances[index];
    _showMessage(
      instance.isRunning ? 'Instancia "${instance.name}" iniciada.' : 'Instancia "${instance.name}" detenida.',
      success: instance.isRunning,
    );
  }

  // Eliminar una base de datos
  void _deleteInstance(int index) {
    final instance = _instances[index];
    setState(() => _instances.removeAt(index));
    _showMessage('Instancia "${instance.name}" eliminada.', success: false);
  }

  // Título dinámico para la barra superior
  String get _currentTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Resumen General';
      case 1:
        return 'Mis Bases de Datos';
      case 2:
        return 'Herramientas de Desarrollo';
      case 3:
        return 'Documentación y Guías';
      case 4:
        return 'Mi Cuenta y Ajustes';
      default:
        return 'Dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      // Drawer de navegación lateral para pantallas móviles
      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                selectedIndex: _selectedIndex,
                onSelect: (index) {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context); // Cierra el drawer al seleccionar
                },
              ),
            )
          : null,
      body: Row(
        children: [
          // Menú lateral fijo para pantallas de escritorio (isDesktop = true)
          if (isDesktop)
            DashboardSidebar(
              selectedIndex: _selectedIndex,
              onSelect: (index) => setState(() => _selectedIndex = index),
            ),

          // Área principal derecha (Topbar + Sub-pestañas activas)
          Expanded(
            child: Column(
              children: [
                // Barra de navegación superior
                DashboardTopbar(
                  title: _currentTitle,
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                  onCreateDatabase: _openCreateDatabaseDialog,
                ),

                // Sub-páginas renderizadas dinámicamente según _selectedIndex
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // 0: Resumen (Overview)
                      OverviewPage(
                        instances: _instances,
                        onCreateDatabase: _openCreateDatabaseDialog,
                        onGoDatabases: () => setState(() => _selectedIndex = 1),
                        onGoDocumentation: () => setState(() => _selectedIndex = 3),
                      ),
                      // 1: Bases de Datos (Databases)
                      DatabasesPage(
                        instances: _instances,
                        onCreateDatabase: _openCreateDatabaseDialog,
                        onToggleState: _toggleInstanceState,
                        onDelete: _deleteInstance,
                        onMessage: _showMessage,
                      ),
                      // 2: Herramientas (Tools)
                      ToolsPage(onMessage: _showMessage),
                      // 3: Documentación (Documentation)
                      DocumentationPage(onMessage: _showMessage),
                      // 4: Mi Cuenta (Account)
                      AccountPage(onMessage: _showMessage),
                    ],
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
