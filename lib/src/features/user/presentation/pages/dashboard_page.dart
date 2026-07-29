import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
// Domain
import 'package:frontend_landing/src/features/user/presentation/pages/account_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/databases_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/documentation_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/overview_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/pages/tools_page.dart'; // Pages
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/create_database_dialog.dart'; // Dialogs
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/new_database_credentials_dialog.dart'; // Dialogs
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/dashboard_sidebar.dart'; // Layout
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/dashboard_topbar.dart'; // Layout

/// ¿Qué hace?: Vista contenedora principal del Portal de Usuario que administra el estado global, navegación y las 5 pestañas.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), componentes de layout, dialogs y las 5 sub-páginas (pages).
/// ¿Hacia dónde va / Cómo se conecta?: Es la pantalla de inicio principal del panel de usuario registrada en las rutas de la aplicación.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});
  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex =
      0; // 0: Resumen, 1: BD, 2: Herramientas, 3: Docs, 4: Cuenta

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

    // Abre el modal de confirmación y, si el usuario confirma, aprovisiona la instancia real
  Future<void> _openCreateDatabaseDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (confirmed != true) return;

    final result = await ref.read(userDatabasesProvider.notifier).createDatabase();

    if (!mounted) return;

    if (!result.success) {
      _showMessage(
        'No se pudo crear la instancia: ${result.errorMessage}',
        success: false,
      );
      return;
    }

    _showMessage('Instancia creada exitosamente en el servidor.');

    // Muestra la contraseña en texto plano una única vez: el backend no la vuelve a exponer así.
    if (result.provisioning != null) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => NewDatabaseCredentialsDialog(
          provisioning: result.provisioning!,
          onMessage: _showMessage,
        ),
      );
    }
  }
  
  // Alternar estado encendido/apagado de una BD
  void _toggleInstanceState(String id) {
    ref.read(userDatabasesProvider.notifier).toggleInstanceState(id);
    _showMessage('Estado de la instancia actualizado.');
  }

  // Eliminar una base de datos con Riverpod
  void _deleteInstance(String id) {
    ref.read(userDatabasesProvider.notifier).deleteDatabase(id);
    _showMessage('Instancia eliminada.', success: false);
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
    // Sintoniza el proveedor global de Riverpod para obtener la lista siempre actualizada
    final instances = ref.watch(userDatabasesProvider);
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
                        instances: instances,
                        onCreateDatabase: _openCreateDatabaseDialog,
                        onGoDatabases: () => setState(() => _selectedIndex = 1),
                        onGoDocumentation: () =>
                            setState(() => _selectedIndex = 3),
                      ),
                      DatabasesPage(
                        instances: instances,
                        onCreateDatabase: _openCreateDatabaseDialog,
                        onToggleState: (index) =>
                            _toggleInstanceState(instances[index].id),
                        onDelete: (index) =>
                            _deleteInstance(instances[index].id),
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
