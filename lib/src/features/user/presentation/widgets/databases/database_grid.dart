// ==========================================
// Qué hace: Grilla responsiva de tarjetas de bases de datos que aplica filtros por motor, estado y búsqueda.
// Dónde se conecta: Se incluye en DatabasesPage.
// De dónde trae datos: Ingesta la lista de instancias y notifica eventos de pausa, reanudación y eliminación al servidor.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart'; // Providers
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/database_management_card.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/databases/empty_databases.dart'; // Databases
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/common/confirm_action_dialog.dart'; // Dialogs

/// Grilla responsiva de tarjetas de bases de datos que aplica filtros en tiempo real
class DatabaseGrid extends ConsumerWidget {
  const DatabaseGrid({
    required this.instances,
    required this.selectedEngine,
    required this.selectedStatus, // Nuevo parámetro para el filtro por estado
    required this.searchQuery,
    required this.onCreate,
    required this.onMessage,
    super.key,
  });

  final List<DatabaseInstance> instances;
  final String selectedEngine;
  final String selectedStatus; // 'Todas', 'Activas', 'Pausadas'
  final String searchQuery;
  final VoidCallback onCreate;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filtra las instancias en tiempo real por motor, texto de búsqueda y estado activo/pausado
    final filtered = instances.where((instance) {
      final matchesFilter = selectedEngine == 'Todos' || instance.engine == selectedEngine;
      final matchesSearch = instance.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          instance.host.toLowerCase().contains(searchQuery.toLowerCase()) ||
          instance.database.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesStatus = selectedStatus == 'Todas' ||
          (selectedStatus == 'Activas' && instance.isRunning) ||
          (selectedStatus == 'Pausadas' && !instance.isRunning);

      return matchesFilter && matchesSearch && matchesStatus;
    }).toList();

    if (filtered.isEmpty) {
      return EmptyDatabases(onCreateDatabase: onCreate);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final int crossAxisCount = width >= 1200 ? 3 : (width >= 768 ? 2 : 1);
        const double spacing = 16.0;
        final double itemWidth = crossAxisCount == 1
            ? width
            : (width - (spacing * (crossAxisCount - 1))) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: filtered.map((instance) {
            return SizedBox(
              width: itemWidth,
              child: DatabaseManagementCard(
                instance: instance,
                // Acción para alternar estado (Pausar o Reanudar) en el backend C#
                onToggleState: () async {
                  onMessage('Procesando solicitud en el servidor...');
                  final result = await ref
                      .read(userDatabasesProvider.notifier)
                      .toggleInstanceState(instance.id, instance.isRunning);

                  if (result.success) {
                    onMessage(
                      instance.isRunning
                          ? 'Instancia pausada correctamente.'
                          : 'Instancia iniciada correctamente.',
                      success: true,
                    );
                  } else {
                    onMessage(
                      result.error ?? 'No se pudo cambiar el estado de la instancia.',
                      success: false,
                    );
                  }
                },
                // Acción para eliminar la instancia en el backend C# con modal de confirmación
                onDelete: () async {
                  final confirmed = await showConfirmDialog(
                    context: context,
                    title: 'Confirmar Eliminación',
                    message:
                        '¿Estás seguro de que deseas eliminar la base de datos "${instance.name}"? Esta acción eliminará la instancia en el servidor.',
                    confirmLabel: 'Sí, eliminar',
                    icon: Icons.delete_forever_rounded,
                    confirmColor: AppColors.error,
                  );

                  if (!confirmed) return;

                  onMessage('Eliminando instancia en el servidor...');
                  final result = await ref
                      .read(userDatabasesProvider.notifier)
                      .deleteDatabase(instance.id);

                  if (result.success) {
                    onMessage('Instancia "${instance.name}" eliminada con éxito.', success: true);
                  } else {
                    onMessage(
                      result.error ?? 'No se pudo eliminar la instancia.',
                      success: false,
                    );
                  }
                },
                onMessage: onMessage,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
