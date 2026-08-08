// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/overview/overview_empty_databases.dart
// ¿Qué hace?: Muestra la tarjeta de estado vacío cuando el usuario no tiene ninguna base de datos creada.
// ¿De dónde trae datos?: Ingesta el callback onCreateDatabase y se adapta al tema activo.
// ¿Hacia dónde va / Cómo se conecta?: Renderizado por OverviewDatabasesGrid cuando la lista de instancias está vacía.
// ==========================================

import 'package:flutter/material.dart';

class OverviewEmptyDatabases extends StatelessWidget {
  const OverviewEmptyDatabases({
    required this.onCreateDatabase,
    super.key,
  });

  final VoidCallback onCreateDatabase; // Callback para abrir modal de creación de BD

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          const Icon(Icons.dns_outlined, size: 36, color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            'Aún no has aprovisionado ninguna base de datos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text(
            'Crea tu primera instancia de PostgreSQL, MySQL o MongoDB en segundos.',
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            onPressed: onCreateDatabase,
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Crear primera Base de Datos'),
          ),
        ],
      ),
    );
  }
}
