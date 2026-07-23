import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RaftDashboardApp());
}

// =============================================================================
// APP Y TEMA
// =============================================================================

class AppColors {
  static const navy = Color(0xFF071D45);
  static const deepNavy = Color(0xFF03132F);
  static const blue = Color(0xFF1177DD);
  static const cyan = Color(0xFF13C9C2);
  static const green = Color(0xFF17B978);
  static const orange = Color(0xFFFFAA3B);
  static const red = Color(0xFFE95462);
  static const purple = Color(0xFF795BEF);

  static const background = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const text = Color(0xFF152640);
  static const muted = Color(0xFF687A91);
  static const border = Color(0xFFE0E7F0);
}

class RaftDashboardApp extends StatelessWidget {
  const RaftDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raft DB Dashboard',
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
        dividerColor: AppColors.border,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF7F9FC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
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
              width: 1.7,
            ),
          ),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

// =============================================================================
// MODELOS
// =============================================================================

class DatabaseInstance {
  DatabaseInstance({
    required this.id,
    required this.name,
    required this.engine,
    required this.version,
    required this.database,
    required this.username,
    required this.host,
    required this.port,
    required this.storageUsed,
    required this.storageLimit,
    required this.createdAt,
    this.isRunning = true,
  });

  final String id;
  final String name;
  final String engine;
  final String version;
  final String database;
  final String username;
  final String host;
  final int port;
  final double storageUsed;
  final double storageLimit;
  final String createdAt;

  bool isRunning;
}

class DatabaseEngine {
  const DatabaseEngine({
    required this.name,
    required this.version,
    required this.port,
    required this.color,
    required this.icon,
  });

  final String name;
  final String version;
  final int port;
  final Color color;
  final IconData icon;
}

// =============================================================================
// DASHBOARD PRINCIPAL
// =============================================================================

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<DatabaseInstance> _instances = [
    DatabaseInstance(
      id: 'db-001',
      name: 'proyecto-universidad',
      engine: 'PostgreSQL',
      version: '16',
      database: 'universidad_db',
      username: 'raft_user_01',
      host: 'pg01.raftdb.dev',
      port: 5432,
      storageUsed: 182,
      storageLimit: 512,
      createdAt: '18 Jul 2026',
    ),
    DatabaseInstance(
      id: 'db-002',
      name: 'api-tienda-demo',
      engine: 'MongoDB',
      version: '7.0',
      database: 'tienda_demo',
      username: 'raft_user_02',
      host: 'mongo02.raftdb.dev',
      port: 27017,
      storageUsed: 96,
      storageLimit: 512,
      createdAt: '20 Jul 2026',
    ),
    DatabaseInstance(
      id: 'db-003',
      name: 'practica-consultas',
      engine: 'MySQL',
      version: '8.0',
      database: 'practica_sql',
      username: 'raft_user_03',
      host: 'mysql03.raftdb.dev',
      port: 3306,
      storageUsed: 48,
      storageLimit: 512,
      createdAt: '21 Jul 2026',
      isRunning: false,
    ),
  ];

  final _pages = const [
    'Resumen',
    'Bases de datos',
    'Herramientas',
    'Documentación',
    'Mi cuenta',
  ];

  void _selectPage(int index) {
    setState(() => _selectedIndex = index);

    final scaffold = Scaffold.maybeOf(context);
    if (scaffold?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? AppColors.green : AppColors.navy,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  Future<void> _createDatabase() async {
    final instance = await showDialog<DatabaseInstance>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (instance == null) return;

    setState(() {
      _instances.add(instance);
      _selectedIndex = 1;
    });

    _showMessage(
      'La instancia "${instance.name}" fue creada correctamente.',
      success: true,
    );
  }

  void _toggleInstance(DatabaseInstance instance) {
    setState(() => instance.isRunning = !instance.isRunning);

    _showMessage(
      instance.isRunning
          ? '${instance.name} se está iniciando.'
          : '${instance.name} fue detenida.',
      success: instance.isRunning,
    );
  }

  Future<void> _deleteInstance(DatabaseInstance instance) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar instancia'),
        content: Text(
          '¿Seguro que deseas eliminar "${instance.name}"?\n\n'
          'Esta acción eliminará todos sus datos y no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Eliminar'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _instances.remove(instance));
    _showMessage('La instancia fue eliminada.');
  }

  void _showCredentials(DatabaseInstance instance) {
    showDialog(
      context: context,
      builder: (context) => CredentialsDialog(
        instance: instance,
        onMessage: _showMessage,
      ),
    );
  }

  Widget _currentContent() {
    switch (_selectedIndex) {
      case 0:
        return OverviewPage(
          instances: _instances,
          onCreateDatabase: _createDatabase,
          onSeeAll: () => setState(() => _selectedIndex = 1),
          onCredentials: _showCredentials,
          onToggle: _toggleInstance,
        );
      case 1:
        return DatabasesPage(
          instances: _instances,
          onCreateDatabase: _createDatabase,
          onCredentials: _showCredentials,
          onToggle: _toggleInstance,
          onDelete: _deleteInstance,
          onMessage: _showMessage,
        );
      case 2:
        return ToolsPage(onMessage: _showMessage);
      case 3:
        return DocumentationPage(onMessage: _showMessage);
      case 4:
        return AccountPage(onMessage: _showMessage);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 980;

        return Scaffold(
          drawer: desktop
              ? null
              : Drawer(
                  width: 280,
                  child: DashboardSidebar(
                    selectedIndex: _selectedIndex,
                    onSelect: (index) {
                      Navigator.pop(context);
                      setState(() => _selectedIndex = index);
                    },
                    onCreateDatabase: () {
                      Navigator.pop(context);
                      _createDatabase();
                    },
                  ),
                ),
          body: Row(
            children: [
              if (desktop)
                SizedBox(
                  width: 260,
                  child: DashboardSidebar(
                    selectedIndex: _selectedIndex,
                    onSelect: _selectPage,
                    onCreateDatabase: _createDatabase,
                  ),
                ),
              Expanded(
                child: Column(
                  children: [
                    DashboardTopbar(
                      title: _pages[_selectedIndex],
                      desktop: desktop,
                      onCreateDatabase: _createDatabase,
                      onMessage: _showMessage,
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 280),
                        switchInCurve: Curves.easeOut,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.025, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey(_selectedIndex),
                          child: _currentContent(),
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

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex,
    required this.onSelect,
    required this.onCreateDatabase,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    const items = [
      SidebarItemData(Icons.dashboard_rounded, 'Resumen'),
      SidebarItemData(Icons.storage_rounded, 'Bases de datos'),
      SidebarItemData(Icons.construction_rounded, 'Herramientas'),
      SidebarItemData(Icons.menu_book_rounded, 'Documentación'),
      SidebarItemData(Icons.person_rounded, 'Mi cuenta'),
    ];

    return Container(
      color: AppColors.deepNavy,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 18),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 9),
              child: RaftLogo(),
            ),
            const SizedBox(height: 35),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'PLATAFORMA',
                style: TextStyle(
                  color: Color(0xFF6E86A6),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 11),
            ...List.generate(
              items.length,
              (index) => SidebarItem(
                data: items[index],
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.blue.withOpacity(0.22),
                    AppColors.cyan.withOpacity(0.10),
                  ],
                ),
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: AppColors.cyan.withOpacity(0.17),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.add_circle_rounded,
                    color: AppColors.cyan,
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Nueva instancia',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Crea una base de datos para tu proyecto.',
                    style: TextStyle(
                      color: Color(0xFF91A6C0),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: onCreateDatabase,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.cyan,
                        foregroundColor: AppColors.deepNavy,
                      ),
                      child: const Text(
                        'Crear ahora',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const SidebarUser(),
          ],
        ),
      ),
    );
  }
}

class SidebarItemData {
  const SidebarItemData(this.icon, this.label);

  final IconData icon;
  final String label;
}

class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.data,
    required this.selected,
    required this.onTap,
    super.key,
  });

  final SidebarItemData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected
            ? AppColors.blue.withOpacity(0.20)
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
                      color: AppColors.blue.withOpacity(0.23),
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
                      : const Color(0xFF8CA1BC),
                ),
                const SizedBox(width: 13),
                Text(
                  data.label,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : const Color(0xFF9BAEC5),
                    fontSize: 14,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                if (selected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                    ),
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

class SidebarUser extends StatelessWidget {
  const SidebarUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF173A67),
          child: Text(
            'AD',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 12,
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
                'Alex Developer',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Plan gratuito',
                style: TextStyle(
                  color: Color(0xFF7E94AF),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.more_vert_rounded,
          color: Color(0xFF7E94AF),
          size: 20,
        ),
      ],
    );
  }
}

// =============================================================================
// TOPBAR
// =============================================================================

class DashboardTopbar extends StatelessWidget {
  const DashboardTopbar({
    required this.title,
    required this.desktop,
    required this.onCreateDatabase,
    required this.onMessage,
    super.key,
  });

  final String title;
  final bool desktop;
  final VoidCallback onCreateDatabase;
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
                  tooltip: 'Abrir menú',
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              title,
              style: TextStyle(
                color: AppColors.text,
                fontSize: desktop ? 21 : 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            if (desktop)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 240),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    isDense: true,
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 20,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 11,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            if (desktop) const SizedBox(width: 12),
            Badge(
              label: const Text('3'),
              child: IconButton(
                tooltip: 'Notificaciones',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const NotificationsDialog(),
                  );
                },
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.text,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (desktop)
              FilledButton.icon(
                onPressed: onCreateDatabase,
                icon: const Icon(Icons.add_rounded, size: 19),
                label: const Text('Nueva instancia'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                ),
              )
            else
              IconButton.filled(
                tooltip: 'Nueva instancia',
                onPressed: onCreateDatabase,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add_rounded),
              ),
          ],
        ),
      ),
    );
  }
}

class RaftLogo extends StatelessWidget {
  const RaftLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
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
        ),
        const SizedBox(width: 10),
        const Text(
          'Raft',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 3),
        const Text(
          'DB',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// PÁGINA: RESUMEN
// =============================================================================

class OverviewPage extends StatelessWidget {
  const OverviewPage({
    required this.instances,
    required this.onCreateDatabase,
    required this.onSeeAll,
    required this.onCredentials,
    required this.onToggle,
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onCreateDatabase;
  final VoidCallback onSeeAll;
  final ValueChanged<DatabaseInstance> onCredentials;
  final ValueChanged<DatabaseInstance> onToggle;

  @override
  Widget build(BuildContext context) {
    final active = instances.where((item) => item.isRunning).length;
    final storage = instances.fold<double>(
      0,
      (total, item) => total + item.storageUsed,
    );

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WelcomeBanner(onCreateDatabase: onCreateDatabase),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1050
                  ? (width - 54) / 4
                  : width >= 600
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  MetricCard(
                    width: cardWidth,
                    icon: Icons.storage_rounded,
                    color: AppColors.blue,
                    value: '${instances.length}',
                    label: 'Instancias totales',
                    detail: '$active en ejecución',
                  ),
                  MetricCard(
                    width: cardWidth,
                    icon: Icons.cloud_done_rounded,
                    color: AppColors.green,
                    value: '$active',
                    label: 'Servicios activos',
                    detail: 'Funcionando correctamente',
                  ),
                  MetricCard(
                    width: cardWidth,
                    icon: Icons.data_usage_rounded,
                    color: AppColors.purple,
                    value: '${storage.toStringAsFixed(0)} MB',
                    label: 'Almacenamiento usado',
                    detail: 'De 2 GB disponibles',
                  ),
                  MetricCard(
                    width: cardWidth,
                    icon: Icons.speed_rounded,
                    color: AppColors.orange,
                    value: '99.9%',
                    label: 'Disponibilidad',
                    detail: 'Últimos 30 días',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 900;

              if (!desktop) {
                return Column(
                  children: [
                    const UsageChartCard(),
                    const SizedBox(height: 18),
                    AccountUsageCard(
                      instanceCount: instances.length,
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 2, child: UsageChartCard()),
                  const SizedBox(width: 18),
                  Expanded(
                    child: AccountUsageCard(
                      instanceCount: instances.length,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Instancias recientes',
            subtitle: 'Administra tus bases de datos más recientes.',
            actionLabel: 'Ver todas',
            onAction: onSeeAll,
          ),
          const SizedBox(height: 15),
          if (instances.isEmpty)
            EmptyDatabases(onCreate: onCreateDatabase)
          else
            ...instances.take(3).map(
                  (instance) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CompactDatabaseCard(
                      instance: instance,
                      onCredentials: () => onCredentials(instance),
                      onToggle: () => onToggle(instance),
                    ),
                  ),
                ),
          const SizedBox(height: 12),
          const ActivitySection(),
        ],
      ),
    );
  }
}

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    required this.onCreateDatabase,
    super.key, required VoidCallback onGoDocumentation,
  });

  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.navy,
            Color(0xFF0B4176),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 650;

          final content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '¡Hola, Alex! 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tus servicios se encuentran funcionando correctamente.',
                style: TextStyle(
                  color: Color(0xFFB7C9DE),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 21),
              FilledButton.icon(
                onPressed: onCreateDatabase,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Crear base de datos'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  foregroundColor: AppColors.deepNavy,
                ),
              ),
            ],
          );

          final status = Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: Color(0xFF164D61),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.cyan,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Todos los sistemas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Operando normalmente',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 12,
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
                content,
                const SizedBox(height: 22),
                status,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: content),
              status,
            ],
          );
        },
      ),
    );
  }
}

class MetricCard extends StatelessWidget {
  const MetricCard({
    required this.width,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.detail,
    super.key,
  });

  final double width;
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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
        ],
      ),
    );
  }
}

class UsageChartCard extends StatelessWidget {
  const UsageChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
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
                      'Actividad de conexiones',
                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Conexiones durante los últimos siete días',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              ChartLegend(
                color: AppColors.blue,
                label: 'Conexiones',
              ),
            ],
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: CustomPaint(
              painter: UsageChartPainter(),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ChartDay('Lun'),
              ChartDay('Mar'),
              ChartDay('Mié'),
              ChartDay('Jue'),
              ChartDay('Vie'),
              ChartDay('Sáb'),
              ChartDay('Dom'),
            ],
          ),
        ],
      ),
    );
  }
}

class UsageChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        grid,
      );
    }

    const values = [0.30, 0.47, 0.38, 0.72, 0.58, 0.82, 0.66];

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < values.length; i++) {
      final x = size.width * i / (values.length - 1);
      final y = size.height * (1 - values[i]);

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
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
            AppColors.blue.withOpacity(0.25),
            AppColors.blue.withOpacity(0.01),
          ],
        ).createShader(Offset.zero & size),
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.blue
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
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
        3.3,
        Paint()..color = AppColors.blue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ChartDay extends StatelessWidget {
  const ChartDay(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 10,
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({
    required this.color,
    required this.label,
    super.key,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class AccountUsageCard extends StatelessWidget {
  const AccountUsageCard({
    required this.instanceCount,
    super.key,
  });

  final int instanceCount;

  @override
  Widget build(BuildContext context) {
    final usage = math.min(instanceCount / 5, 1.0);

    return DashboardCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Uso del plan',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Plan gratuito para desarrollo',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 25),
          UsageProgress(
            label: 'Instancias',
            valueLabel: '$instanceCount de 5',
            value: usage,
            color: AppColors.blue,
          ),
          const SizedBox(height: 20),
          const UsageProgress(
            label: 'Almacenamiento',
            valueLabel: '326 MB de 2 GB',
            value: 0.16,
            color: AppColors.purple,
          ),
          const SizedBox(height: 20),
          const UsageProgress(
            label: 'Transferencia',
            valueLabel: '1.8 GB de 10 GB',
            value: 0.18,
            color: AppColors.cyan,
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.workspace_premium_outlined),
              label: const Text('Mejorar plan'),
            ),
          ),
        ],
      ),
    );
  }
}

class UsageProgress extends StatelessWidget {
  const UsageProgress({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final String valueLabel;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppColors.text,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              valueLabel,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            color: color,
            backgroundColor: color.withOpacity(0.10),
          ),
        ),
      ],
    );
  }
}

class CompactDatabaseCard extends StatelessWidget {
  const CompactDatabaseCard({
    required this.instance,
    required this.onCredentials,
    required this.onToggle,
    super.key,
  });

  final DatabaseInstance instance;
  final VoidCallback onCredentials;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(instance.engine);

    return DashboardCard(
      padding: const EdgeInsets.all(17),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 630;

          final information = Row(
            children: [
              EngineIcon(
                icon: style.icon,
                color: style.color,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instance.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${instance.engine} ${instance.version} · '
                      '${instance.host}',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(running: instance.isRunning),
            ],
          );

          final actions = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                onPressed: onCredentials,
                icon: const Icon(Icons.key_rounded, size: 17),
                label: const Text('Conectar'),
              ),
              const SizedBox(width: 8),
              IconButton(
                tooltip: instance.isRunning ? 'Detener' : 'Iniciar',
                onPressed: onToggle,
                icon: Icon(
                  instance.isRunning
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_rounded,
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              children: [
                information,
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: actions,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: information),
              const SizedBox(width: 18),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Actividad reciente',
          subtitle: 'Últimos eventos de tu cuenta.',
        ),
        const SizedBox(height: 15),
        DashboardCard(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: const Column(
            children: [
              ActivityItem(
                color: AppColors.green,
                icon: Icons.play_arrow_rounded,
                title: 'Instancia iniciada',
                description: 'api-tienda-demo está disponible.',
                time: 'Hace 12 min',
              ),
              Divider(height: 1),
              ActivityItem(
                color: AppColors.blue,
                icon: Icons.key_rounded,
                title: 'Credenciales consultadas',
                description: 'Acceso a proyecto-universidad.',
                time: 'Hace 1 h',
              ),
              Divider(height: 1),
              ActivityItem(
                color: AppColors.purple,
                icon: Icons.storage_rounded,
                title: 'Nueva instancia creada',
                description: 'Se creó practica-consultas.',
                time: 'Ayer',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  const ActivityItem({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.time,
    super.key,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          CircleAvatar(
            radius: 19,
            backgroundColor: color.withOpacity(0.11),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
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
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
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

// =============================================================================
// PÁGINA: BASES DE DATOS
// =============================================================================

class DatabasesPage extends StatefulWidget {
  const DatabasesPage({
    required this.instances,
    required this.onCreateDatabase,
    required this.onCredentials,
    required this.onToggle,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onCreateDatabase;
  final ValueChanged<DatabaseInstance> onCredentials;
  final ValueChanged<DatabaseInstance> onToggle;
  final ValueChanged<DatabaseInstance> onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  State<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends State<DatabasesPage> {
  String _query = '';
  String _filter = 'Todas';

  List<DatabaseInstance> get filteredInstances {
    return widget.instances.where((instance) {
      final matchesQuery =
          instance.name.toLowerCase().contains(_query.toLowerCase()) ||
              instance.engine.toLowerCase().contains(_query.toLowerCase());

      final matchesFilter = _filter == 'Todas' ||
          (_filter == 'Activas' && instance.isRunning) ||
          (_filter == 'Detenidas' && !instance.isRunning);

      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Mis bases de datos',
            subtitle:
                'Crea, administra y conecta las instancias de tus proyectos.',
            actionLabel: 'Nueva instancia',
            actionIcon: Icons.add_rounded,
            onAction: widget.onCreateDatabase,
          ),
          const SizedBox(height: 22),
          DashboardCard(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 620;

                final search = TextField(
                  onChanged: (value) => setState(() => _query = value),
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre o motor...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                );

                final filter = DropdownButtonFormField<String>(
                  value: _filter,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.filter_list_rounded),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Todas',
                      child: Text('Todas'),
                    ),
                    DropdownMenuItem(
                      value: 'Activas',
                      child: Text('Activas'),
                    ),
                    DropdownMenuItem(
                      value: 'Detenidas',
                      child: Text('Detenidas'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _filter = value);
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
                    const SizedBox(width: 14),
                    SizedBox(width: 180, child: filter),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (filteredInstances.isEmpty)
            EmptyDatabases(onCreate: widget.onCreateDatabase)
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cardWidth =
                    width >= 1050 ? (width - 18) / 2 : width;

                return Wrap(
                  spacing: 18,
                  runSpacing: 18,
                  children: filteredInstances
                      .map(
                        (instance) => DatabaseManagementCard(
                          width: cardWidth,
                          instance: instance,
                          onCredentials: () =>
                              widget.onCredentials(instance),
                          onToggle: () => widget.onToggle(instance),
                          onDelete: () => widget.onDelete(instance),
                          onMessage: widget.onMessage,
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

class DatabaseManagementCard extends StatelessWidget {
  const DatabaseManagementCard({
    required this.width,
    required this.instance,
    required this.onCredentials,
    required this.onToggle,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final double width;
  final DatabaseInstance instance;
  final VoidCallback onCredentials;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(instance.engine);
    final progress = instance.storageUsed / instance.storageLimit;

    return DashboardCard(
      width: width,
      padding: const EdgeInsets.all(21),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EngineIcon(
                icon: style.icon,
                color: style.color,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      instance.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${instance.engine} ${instance.version}',
                      style: TextStyle(
                        color: style.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(running: instance.isRunning),
              PopupMenuButton<String>(
                tooltip: 'Más opciones',
                onSelected: (value) {
                  if (value == 'restart') {
                    onMessage(
                      'La instancia ${instance.name} se está reiniciando.',
                      success: true,
                    );
                  }

                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'restart',
                    child: Row(
                      children: [
                        Icon(Icons.restart_alt_rounded),
                        SizedBox(width: 10),
                        Text('Reiniciar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Eliminar',
                          style: TextStyle(color: AppColors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 22),
          InfoLine(
            icon: Icons.language_rounded,
            label: 'Host',
            value: instance.host,
          ),
          const SizedBox(height: 10),
          InfoLine(
            icon: Icons.dns_outlined,
            label: 'Base de datos',
            value: instance.database,
          ),
          const SizedBox(height: 10),
          InfoLine(
            icon: Icons.calendar_today_outlined,
            label: 'Creada',
            value: instance.createdAt,
          ),
          const SizedBox(height: 21),
          Row(
            children: [
              const Text(
                'Almacenamiento',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                '${instance.storageUsed.toStringAsFixed(0)} MB / '
                '${instance.storageLimit.toStringAsFixed(0)} MB',
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              color: style.color,
              backgroundColor: style.color.withOpacity(0.10),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: instance.isRunning ? onCredentials : null,
                  icon: const Icon(Icons.key_rounded, size: 17),
                  label: const Text('Conectar'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: onToggle,
                icon: Icon(
                  instance.isRunning
                      ? Icons.stop_circle_outlined
                      : Icons.play_circle_outline_rounded,
                  size: 18,
                ),
                label: Text(
                  instance.isRunning ? 'Detener' : 'Iniciar',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EmptyDatabases extends StatelessWidget {
  const EmptyDatabases({
    required this.onCreate,
    super.key,
  });

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 55,
      ),
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storage_rounded,
              color: AppColors.blue,
              size: 36,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No encontramos instancias',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Crea una nueva base de datos para comenzar.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Crear instancia'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: HERRAMIENTAS
// =============================================================================

class ToolsPage extends StatelessWidget {
  const ToolsPage({
    required this.onMessage,
    super.key,
  });

  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    const tools = [
      ToolData(
        Icons.cable_rounded,
        'Probar conexión',
        'Verifica que las credenciales y el host respondan correctamente.',
        AppColors.blue,
      ),
      ToolData(
        Icons.terminal_rounded,
        'Consola SQL',
        'Ejecuta consultas básicas desde el navegador.',
        AppColors.purple,
      ),
      ToolData(
        Icons.dataset_rounded,
        'Generador de datos',
        'Genera registros ficticios para tus pruebas y prototipos.',
        AppColors.green,
      ),
      ToolData(
        Icons.upload_file_rounded,
        'Importar datos',
        'Carga archivos SQL, CSV o JSON en una instancia.',
        AppColors.orange,
      ),
      ToolData(
        Icons.download_rounded,
        'Exportar información',
        'Descarga una copia de los datos de tus proyectos.',
        AppColors.cyan,
      ),
      ToolData(
        Icons.monitor_heart_rounded,
        'Estado de servicios',
        'Consulta disponibilidad y eventos de infraestructura.',
        AppColors.red,
      ),
    ];

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Herramientas',
            subtitle:
                'Utilidades para probar, consultar y administrar tus datos.',
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth = width >= 1000
                  ? (width - 36) / 3
                  : width >= 620
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: tools
                    .map(
                      (tool) => ToolCard(
                        width: cardWidth,
                        data: tool,
                        onOpen: () => onMessage(
                          'Abriendo ${tool.title.toLowerCase()}...',
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Conexión rápida',
            subtitle: 'Ejemplo de conexión a PostgreSQL desde Flutter.',
          ),
          const SizedBox(height: 15),
          const CodePreview(),
        ],
      ),
    );
  }
}

class ToolData {
  const ToolData(
    this.icon,
    this.title,
    this.description,
    this.color,
  );

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}

class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.width,
    required this.data,
    required this.onOpen,
    super.key,
  });

  final double width;
  final ToolData data;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      width: width,
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.11),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(data.icon, color: data.color),
          ),
          const SizedBox(height: 18),
          Text(
            data.title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 19),
          TextButton.icon(
            onPressed: onOpen,
            iconAlignment: IconAlignment.end,
            icon: const Icon(Icons.arrow_forward_rounded, size: 18),
            label: const Text('Abrir herramienta'),
          ),
        ],
      ),
    );
  }
}

class CodePreview extends StatelessWidget {
  const CodePreview({super.key});

  @override
  Widget build(BuildContext context) {
    const code = '''
final connection = PostgreSQLConnection(
  'pg01.raftdb.dev',
  5432,
  'universidad_db',
  username: 'raft_user_01',
  password: '••••••••••',
);

await connection.open();
print('Conexión establecida');''';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(19),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            color: const Color(0xFF0B254B),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.red,
                ),
                const SizedBox(width: 7),
                const CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.orange,
                ),
                const SizedBox(width: 7),
                const CircleAvatar(
                  radius: 5,
                  backgroundColor: AppColors.green,
                ),
                const Spacer(),
                const Text(
                  'Flutter / Dart',
                  style: TextStyle(
                    color: Color(0xFF92A8C2),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  tooltip: 'Copiar código',
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código copiado.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy_rounded,
                    color: Color(0xFF92A8C2),
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(22),
              child: SelectableText(
                code,
                style: TextStyle(
                  color: Color(0xFFD2E3F5),
                  fontFamily: 'monospace',
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: DOCUMENTACIÓN
// =============================================================================

class DocumentationPage extends StatelessWidget {
  const DocumentationPage({
    required this.onMessage,
    super.key,
  });

  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    const guides = [
      GuideData(
        Icons.rocket_launch_rounded,
        'Primeros pasos',
        'Aprende a crear y conectar tu primera instancia.',
        '5 min',
      ),
      GuideData(
        Icons.storage_rounded,
        'Conectar PostgreSQL',
        'Configura una conexión desde tus aplicaciones.',
        '8 min',
      ),
      GuideData(
        Icons.eco_rounded,
        'Trabajar con MongoDB',
        'Conecta clientes y administra tus colecciones.',
        '7 min',
      ),
      GuideData(
        Icons.security_rounded,
        'Seguridad y credenciales',
        'Recomendaciones para proteger tus conexiones.',
        '6 min',
      ),
    ];

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Documentación',
            subtitle:
                'Guías y recursos para aprovechar los servicios de Raft DB.',
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(27),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blue, Color(0xFF0B5FB4)],
              ),
              borderRadius: BorderRadius.circular(23),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.menu_book_rounded,
                  color: Colors.white,
                  size: 36,
                ),
                const SizedBox(height: 15),
                const Text(
                  '¿Qué deseas aprender?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Busca motores, conexiones, consultas o herramientas.',
                  style: TextStyle(color: Color(0xFFD6E9FF)),
                ),
                const SizedBox(height: 19),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Buscar en la documentación...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      suffixIcon: IconButton(
                        onPressed: () => onMessage(
                          'Buscando en la documentación...',
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const SectionHeader(
            title: 'Guías recomendadas',
            subtitle: 'Recursos para comenzar rápidamente.',
          ),
          const SizedBox(height: 15),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cardWidth =
                  width >= 850 ? (width - 18) / 2 : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: guides
                    .map(
                      (guide) => GuideCard(
                        width: cardWidth,
                        data: guide,
                        onOpen: () => onMessage(
                          'Abriendo la guía "${guide.title}".',
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

class GuideData {
  const GuideData(
    this.icon,
    this.title,
    this.description,
    this.time,
  );

  final IconData icon;
  final String title;
  final String description;
  final String time;
}

class GuideCard extends StatelessWidget {
  const GuideCard({
    required this.width,
    required this.data,
    required this.onOpen,
    super.key,
  });

  final double width;
  final GuideData data;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      width: width,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 51,
            height: 51,
            decoration: BoxDecoration(
              color: AppColors.blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(data.icon, color: AppColors.blue),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${data.time} de lectura',
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onOpen,
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// PÁGINA: CUENTA
// =============================================================================

class AccountPage extends StatefulWidget {
  const AccountPage({
    required this.onMessage,
    super.key,
  });

  final void Function(String, {bool success}) onMessage;

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _nameController = TextEditingController(text: 'Alex Developer');
  final _emailController = TextEditingController(text: 'alex@correo.com');

  bool _emailNotifications = true;
  bool _serviceNotifications = true;
  bool _securityNotifications = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Mi cuenta',
            subtitle: 'Administra tus datos, seguridad y preferencias.',
          ),
          const SizedBox(height: 22),
          LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 850;

              final profile = DashboardCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingsTitle(
                      icon: Icons.person_outline_rounded,
                      title: 'Información personal',
                    ),
                    const SizedBox(height: 23),
                    const Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: Color(0xFFE1EEFB),
                            child: Text(
                              'AD',
                              style: TextStyle(
                                color: AppColors.blue,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Positioned(
                            right: -3,
                            bottom: -3,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.navy,
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    const FieldLabel('Nombre'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 17),
                    const FieldLabel('Correo electrónico'),
                    const SizedBox(height: 7),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 21),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => widget.onMessage(
                          'Los cambios fueron guardados.',
                          success: true,
                        ),
                        child: const Text('Guardar cambios'),
                      ),
                    ),
                  ],
                ),
              );

              final settings = Column(
                children: [
                  DashboardCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsTitle(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notificaciones',
                        ),
                        const SizedBox(height: 14),
                        SettingsSwitch(
                          title: 'Novedades por correo',
                          subtitle:
                              'Recibe noticias y mejoras de la plataforma.',
                          value: _emailNotifications,
                          onChanged: (value) {
                            setState(() => _emailNotifications = value);
                          },
                        ),
                        SettingsSwitch(
                          title: 'Estado de servicios',
                          subtitle:
                              'Avisos sobre tus instancias y mantenimiento.',
                          value: _serviceNotifications,
                          onChanged: (value) {
                            setState(() => _serviceNotifications = value);
                          },
                        ),
                        SettingsSwitch(
                          title: 'Alertas de seguridad',
                          subtitle:
                              'Inicios de sesión y cambios de credenciales.',
                          value: _securityNotifications,
                          onChanged: (value) {
                            setState(() => _securityNotifications = value);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  DashboardCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SettingsTitle(
                          icon: Icons.security_rounded,
                          title: 'Seguridad',
                        ),
                        const SizedBox(height: 20),
                        SettingsAction(
                          icon: Icons.lock_outline_rounded,
                          title: 'Cambiar contraseña',
                          subtitle: 'Último cambio hace 30 días',
                          onTap: () => widget.onMessage(
                            'Abriendo cambio de contraseña...',
                          ),
                        ),
                        const Divider(height: 28),
                        SettingsAction(
                          icon: Icons.devices_rounded,
                          title: 'Sesiones activas',
                          subtitle: '2 dispositivos conectados',
                          onTap: () => widget.onMessage(
                            'Mostrando sesiones activas...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );

              if (!desktop) {
                return Column(
                  children: [
                    profile,
                    const SizedBox(height: 18),
                    settings,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: profile),
                  const SizedBox(width: 18),
                  Expanded(flex: 2, child: settings),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsTitle extends StatelessWidget {
  const SettingsTitle({
    required this.icon,
    required this.title,
    super.key,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.blue),
        const SizedBox(width: 9),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class SettingsSwitch extends StatelessWidget {
  const SettingsSwitch({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      activeColor: AppColors.blue,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.text,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 11,
        ),
      ),
    );
  }
}

class SettingsAction extends StatelessWidget {
  const SettingsAction({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.blue.withOpacity(0.10),
            child: Icon(icon, color: AppColors.blue, size: 20),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
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
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.muted,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DIÁLOGO: CREAR BASE DE DATOS
// =============================================================================

class CreateDatabaseDialog extends StatefulWidget {
  const CreateDatabaseDialog({super.key});

  @override
  State<CreateDatabaseDialog> createState() =>
      _CreateDatabaseDialogState();
}

class _CreateDatabaseDialogState extends State<CreateDatabaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  final List<DatabaseEngine> _engines = const [
    DatabaseEngine(
      name: 'PostgreSQL',
      version: '16',
      port: 5432,
      color: Color(0xFF3977A8),
      icon: Icons.storage_rounded,
    ),
    DatabaseEngine(
      name: 'MySQL',
      version: '8.0',
      port: 3306,
      color: AppColors.blue,
      icon: Icons.dns_rounded,
    ),
    DatabaseEngine(
      name: 'SQL Server',
      version: '2022',
      port: 1433,
      color: AppColors.red,
      icon: Icons.table_chart_rounded,
    ),
    DatabaseEngine(
      name: 'MongoDB',
      version: '7.0',
      port: 27017,
      color: AppColors.green,
      icon: Icons.eco_rounded,
    ),
  ];

  int _selectedEngine = 0;
  bool _creating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _creating = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;

    final engine = _engines[_selectedEngine];
    final slug = _nameController.text
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');

    final random = math.Random().nextInt(80) + 10;

    Navigator.pop(
      context,
      DatabaseInstance(
        id: 'db-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        engine: engine.name,
        version: engine.version,
        database: '${slug}_db',
        username: 'raft_user_$random',
        host: '${engine.name.toLowerCase().replaceAll(' ', '')}'
            '$random.raftdb.dev',
        port: engine.port,
        storageUsed: 0,
        storageLimit: 512,
        createdAt: '23 Jul 2026',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE0EEFC),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColors.blue,
                      ),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crear nueva instancia',
                            style: TextStyle(
                              color: AppColors.text,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Selecciona el motor para tu proyecto.',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed:
                          _creating ? null : () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const FieldLabel('Nombre de la instancia'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Ejemplo: proyecto-universidad',
                    prefixIcon: Icon(Icons.edit_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Ingresa un nombre para la instancia.';
                    }

                    if (value.trim().length < 3) {
                      return 'El nombre debe tener al menos 3 caracteres.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 22),
                const FieldLabel('Motor de base de datos'),
                const SizedBox(height: 12),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final itemWidth =
                        width >= 500 ? (width - 12) / 2 : width;

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: List.generate(
                        _engines.length,
                        (index) {
                          final engine = _engines[index];
                          final selected = _selectedEngine == index;

                          return InkWell(
                            onTap: _creating
                                ? null
                                : () {
                                    setState(() {
                                      _selectedEngine = index;
                                    });
                                  },
                            borderRadius: BorderRadius.circular(15),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: itemWidth,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: selected
                                    ? engine.color.withOpacity(0.08)
                                    : const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selected
                                      ? engine.color
                                      : AppColors.border,
                                  width: selected ? 1.7 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  EngineIcon(
                                    icon: engine.icon,
                                    color: engine.color,
                                    small: true,
                                  ),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          engine.name,
                                          style: const TextStyle(
                                            color: AppColors.text,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        Text(
                                          'Versión ${engine.version}',
                                          style: const TextStyle(
                                            color: AppColors.muted,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selected)
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: engine.color,
                                      size: 20,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 23),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFFD4E8FC),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.blue,
                      ),
                      SizedBox(width: 11),
                      Expanded(
                        child: Text(
                          'La instancia gratuita incluye 512 MB de '
                          'almacenamiento y acceso remoto.',
                          style: TextStyle(
                            color: Color(0xFF44617F),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed:
                          _creating ? null : () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 10),
                    FilledButton.icon(
                      onPressed: _creating ? null : _create,
                      icon: _creating
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.rocket_launch_rounded),
                      label: Text(
                        _creating ? 'Creando...' : 'Crear instancia',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// DIÁLOGO: CREDENCIALES
// =============================================================================

class CredentialsDialog extends StatefulWidget {
  const CredentialsDialog({
    required this.instance,
    required this.onMessage,
    super.key,
  });

  final DatabaseInstance instance;
  final void Function(String, {bool success}) onMessage;

  @override
  State<CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends State<CredentialsDialog> {
  bool _showPassword = false;

  String get _password => 'Rft_9xK2mQ7pL4';

  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    widget.onMessage('$label copiado.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final instance = widget.instance;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE3F0FC),
                    child: Icon(
                      Icons.key_rounded,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Credenciales de conexión',
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          instance.name,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
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
              CredentialItem(
                label: 'Host',
                value: instance.host,
                onCopy: () => _copy('Host', instance.host),
              ),
              CredentialItem(
                label: 'Puerto',
                value: '${instance.port}',
                onCopy: () => _copy('Puerto', '${instance.port}'),
              ),
              CredentialItem(
                label: 'Base de datos',
                value: instance.database,
                onCopy: () => _copy(
                  'Base de datos',
                  instance.database,
                ),
              ),
              CredentialItem(
                label: 'Usuario',
                value: instance.username,
                onCopy: () => _copy('Usuario', instance.username),
              ),
              CredentialItem(
                label: 'Contraseña',
                value: _showPassword ? _password : '••••••••••••••',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Copiar',
                      onPressed: () => _copy('Contraseña', _password),
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E9),
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: const Color(0xFFFFE5AF),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFD98A00),
                    ),
                    SizedBox(width: 11),
                    Expanded(
                      child: Text(
                        'No compartas estas credenciales ni las publiques '
                        'en repositorios de código.',
                        style: TextStyle(
                          color: Color(0xFF76561D),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final uri = '${instance.engine.toLowerCase()}://'
                        '${instance.username}:$_password@'
                        '${instance.host}:${instance.port}/'
                        '${instance.database}';

                    _copy('Cadena de conexión', uri);
                  },
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Copiar cadena de conexión'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CredentialItem extends StatelessWidget {
  const CredentialItem({
    required this.label,
    required this.value,
    this.onCopy,
    this.trailing,
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F9FC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    value,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                trailing ??
                    IconButton(
                      tooltip: 'Copiar',
                      onPressed: onCopy,
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 18,
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

// =============================================================================
// NOTIFICACIONES
// =============================================================================

class NotificationsDialog extends StatelessWidget {
  const NotificationsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.notifications_none_rounded),
          SizedBox(width: 9),
          Text('Notificaciones'),
        ],
      ),
      content: const SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NotificationItem(
              color: AppColors.green,
              title: 'Instancia disponible',
              description: 'api-tienda-demo está funcionando.',
              time: 'Hace 12 min',
            ),
            Divider(),
            NotificationItem(
              color: AppColors.blue,
              title: 'Nueva guía disponible',
              description: 'Aprende a conectar PostgreSQL con Flutter.',
              time: 'Hace 3 h',
            ),
            Divider(),
            NotificationItem(
              color: AppColors.orange,
              title: 'Mantenimiento programado',
              description: 'Domingo a las 02:00 UTC.',
              time: 'Ayer',
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

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    required this.color,
    required this.title,
    required this.description,
    required this.time,
    super.key,
  });

  final Color color;
  final String title;
  final String description;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: CircleAvatar(radius: 5, backgroundColor: color),
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
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: AppColors.blue,
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

// =============================================================================
// COMPONENTES COMPARTIDOS
// =============================================================================

class DashboardScrollView extends StatelessWidget {
  const DashboardScrollView({
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
          constraints: const BoxConstraints(maxWidth: 1280),
          child: child,
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({
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

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
    super.key,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
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
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (actionLabel != null && onAction != null)
          actionIcon == null
              ? TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel!),
                )
              : FilledButton.icon(
                  onPressed: onAction,
                  icon: Icon(actionIcon, size: 18),
                  label: Text(actionLabel!),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),
      ],
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
    case 'SQL Server':
      return const EngineStyle(
        Icons.table_chart_rounded,
        AppColors.red,
      );
    case 'MongoDB':
      return const EngineStyle(
        Icons.eco_rounded,
        AppColors.green,
      );
    default:
      return const EngineStyle(
        Icons.storage_rounded,
        AppColors.muted,
      );
  }
}

class EngineIcon extends StatelessWidget {
  const EngineIcon({
    required this.icon,
    required this.color,
    this.small = false,
    super.key,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 40.0 : 48.0;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.11),
        borderRadius: BorderRadius.circular(small ? 12 : 14),
      ),
      child: Icon(
        icon,
        color: color,
        size: small ? 21 : 25,
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.running,
    super.key,
  });

  final bool running;

  @override
  Widget build(BuildContext context) {
    final color = running ? AppColors.green : AppColors.muted;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        running ? '● Activa' : '● Detenida',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class InfoLine extends StatelessWidget {
  const InfoLine({
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
        const SizedBox(width: 9),
        Text(
          '$label:',
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 11,
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
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.text,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}