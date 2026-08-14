import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/account_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/ai_services_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/databases_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/dns_ssl_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/n8n_services_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/overview_page.dart';
import 'package:frontend_landing/src/features/user/presentation/pages/tools_and_docs_page.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/dashboard_sidebar.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/topbar/dashboard_topbar.dart';

/// ¿Qué hace?: Shell contenedor principal del panel de usuario que administra la navegación y sub-páginas.
/// ¿De dónde trae datos?: Maneja el estado del índice seleccionado (_selectedIndex) y la barra lateral/superior.
/// ¿Hacia dónde va / Cómo se conecta?: Es la pantalla raíz registrada en la ruta /dashboard del GoRouter.
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0; // Índice de la pestaña activa

  /// Notificación snackbar flotante
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

  /// Redirección al aprovisionamiento de bases de datos
  void _openCreateDatabaseDialog() {
    setState(() => _selectedIndex = 1);
  }

  /// Título dinámico para la barra superior según la pestaña activa
  String get _currentTitle {
    switch (_selectedIndex) {
      case 0:
        return 'Resumen General';
      case 1:
        return 'Mis Bases de Datos';
      case 2:
        return 'Dominio & SSL (DNS)';
      case 3:
        return 'Servicios de IA';
      case 4:
        return 'Workflows & Automatización (n8n)';
      case 5:
        return 'Herramientas y Guías';
      case 6:
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: !isDesktop
          ? Drawer(
              child: DashboardSidebar(
                selectedIndex: _selectedIndex,
                onSelect: (index) {
                  setState(() => _selectedIndex = index);
                  Navigator.pop(context);
                },
              ),
            )
          : null,
      body: Row(
        children: [
          if (isDesktop)
            DashboardSidebar(
              selectedIndex: _selectedIndex,
              onSelect: (index) => setState(() => _selectedIndex = index),
            ),
          Expanded(
            child: Column(
              children: [
                DashboardTopbar(
                  title: _currentTitle,
                  onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                  onCreateDatabase: _openCreateDatabaseDialog,
                  onSelectTab: (index) => setState(() => _selectedIndex = index), // Permite cambiar de pestaña desde el Hub
                  onMessage: _showMessage, // Conecta las notificaciones SnackBar del Dashboard
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: [
                      // 0: Resumen (Overview)
                      OverviewPage(
                        onCreateDatabase: _openCreateDatabaseDialog,
                        onGoDatabases: () => setState(() => _selectedIndex = 1),
                        onGoDns: () => setState(() => _selectedIndex = 2),       // Navega a Dominio & SSL (DNS)
                        onGoAi: () => setState(() => _selectedIndex = 3),        // Navega a Servicios de IA
                        onGoN8n: () => setState(() => _selectedIndex = 4),       // Navega a Workflows (n8n)
                        onGoDocumentation: () =>
                            setState(() => _selectedIndex = 5),
                      ),
                      // 1: Bases de Datos (Autónoma)
                      DatabasesPage(onMessage: _showMessage),
                      // 2: Dominio & SSL
                      DnsSslPage(onMessage: _showMessage),
                      // 3: Servicios de IA
                      AiServicesPage(onMessage: _showMessage),
                      // 4: Workflows (n8n) - NUEVA PÁGINA
                      N8nServicesPage(onMessage: _showMessage),
                      // 5: Herramientas y Guías
                      ToolsAndDocsPage(onMessage: _showMessage),
                      // 6: Mi Cuenta
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
