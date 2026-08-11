// ==========================================
// Qué hace: Vista principal autónoma de Bases de Datos orquestada de forma plana mediante subwidgets.
// Dónde se conecta: Se renderiza en el índice 1 del IndexedStack en DashboardPage.
// De dónde trae datos: Escucha userDatabasesProvider directamente en Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_grid.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_search_filter.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_summary_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/databases/create_database_dialog.dart';

/// Vista principal de administración de bases de datos con filtros reactivos por motor, estado y texto
class DatabasesPage extends ConsumerStatefulWidget {
  const DatabasesPage({required this.onMessage, super.key});

  final void Function(String message, {bool success}) onMessage;

  @override
  ConsumerState<DatabasesPage> createState() => _DatabasesPageState();
}

class _DatabasesPageState extends ConsumerState<DatabasesPage> {
  String _selectedEngine = 'Todos';
  String _selectedStatus = 'Todas'; // 'Todas', 'Activas', 'Pausadas'
  String _searchQuery = '';

  /// Abre el modal de aprovisionamiento de nueva BD
  Future<void> _openCreateDatabaseDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateDatabaseDialog(),
    );

    if (result != null && result.containsKey('engine')) {
      final engineName = result['engine'] as String;

      if (!mounted) return;
      final confirmed = await showConfirmDialog(
        context: context,
        title: 'Confirmar Aprovisionamiento',
        message: '¿Estás seguro de que deseas crear una nueva instancia de $engineName?',
        confirmLabel: 'Sí, crear instancia',
        icon: Icons.rocket_launch_rounded,
        confirmColor: AppColors.navy,
      );

      if (!confirmed) return;

      widget.onMessage('Procesando solicitud de aprovisionamiento...');

      final response = await ref.read(userDatabasesProvider.notifier).createDatabase(engine: engineName);

      if (response.error == null && response.data != null) {
        final data = response.data!;
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('¡Base de Datos Creada!'),
              content: SelectableText(
                'Guarda la contraseña ahora, no se volverá a mostrar completa:\n\n'
                '• Host: ${data['host']}:${data['port']}\n'
                '• Base de datos: ${data['databaseName']}\n'
                '• Usuario: ${data['databaseUser']}\n'
                '• Contraseña: ${data['password']}\n'
                '• Motor: ${data['engine']}',
              ),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Entendido'),
                ),
              ],
            ),
          );
        }
      } else {
        widget.onMessage('No se pudo crear la instancia: ${response.error}', success: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final instances = ref.watch(userDatabasesProvider);

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header de Sección
          SectionHeader(
            title: 'Gestión de Bases de Datos',
            subtitle: 'Administra tus instancias activas, credenciales y motores',
            actionLabel: 'Nueva BD',
            actionIcon: Icons.add_rounded,
            onAction: _openCreateDatabaseDialog,
          ),
          const SizedBox(height: 20),

          // 2. Resumen KPI de Almacenamiento
          DatabaseSummaryCard(instances: instances),
          const SizedBox(height: 20),

          // 3. Buscador y Filtros Combinados por Motor y Estado (Subwidget)
          DatabaseSearchFilter(
            selectedEngine: _selectedEngine,
            selectedStatus: _selectedStatus,
            onSearchChanged: (q) => setState(() => _searchQuery = q),
            onEngineChanged: (e) => setState(() => _selectedEngine = e),
            onStatusChanged: (s) => setState(() => _selectedStatus = s),
          ),
          const SizedBox(height: 24),

          // 4. Grilla Responsiva de Tarjetas (Subwidget)
          DatabaseGrid(
            instances: instances,
            selectedEngine: _selectedEngine,
            selectedStatus: _selectedStatus,
            searchQuery: _searchQuery,
            onCreate: _openCreateDatabaseDialog,
            onMessage: widget.onMessage,
          ),
        ],
      ),
    );
  }
}
