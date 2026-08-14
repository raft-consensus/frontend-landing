// ==========================================
// Qué hace: Macro-sección que ensambla el encabezado de sección y la cuadrícula de instancias recientes de BD.
// Dónde se conecta: Consumido al final de OverviewPage.
// De dónde trae datos: Recibe la lista de DatabaseInstance y callbacks de navegación y creación.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/databases/overview_databases_grid.dart';

/// Sección completa de instancias de bases de datos para el resumen general
class OverviewDatabasesSection extends StatelessWidget {
  const OverviewDatabasesSection({
    required this.instances, // Lista de instancias del usuario
    required this.onGoDatabases, // Callback para ver todas las BDs
    required this.onCreateDatabase, // Callback para crear nueva BD
    super.key,
  });

  final List<DatabaseInstance> instances;
  final VoidCallback onGoDatabases;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Encabezado de la sección
        SectionHeader(
          title: 'Instancias de Bases de Datos',
          subtitle: 'Acceso rápido a tus instancias principales',
          actionLabel: 'Ver todas',
          onAction: onGoDatabases,
        ),
        const SizedBox(height: 14),

        // 2. Cuadrícula de bases de datos
        OverviewDatabasesGrid(
          instances: instances,
          onGoDatabases: onGoDatabases,
          onCreateDatabase: onCreateDatabase,
        ),
      ],
    );
  }
}
