import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Widget gráfico para estados vacíos cuando no hay bases de datos creadas o no hay resultados de búsqueda.
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se muestra dentro de DatabasesPage cuando la lista está vacía.
class EmptyDatabases extends StatelessWidget {
  const EmptyDatabases({
    required this.onCreateDatabase, // Callback para abrir el modal de crear BD
    super.key,
  });

  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono flotante tenue
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.storage_rounded, size: 36, color: AppColors.blue),
          ),
          const SizedBox(height: 16),
          const Text(
            'No hay bases de datos encontradas',
            style: TextStyle(color: AppColors.navy, fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          const Text(
            'Crea tu primera instancia de PostgreSQL, MySQL, MongoDB o SQL Server.',
            style: TextStyle(color: AppColors.muted, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onCreateDatabase,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Crear instancia ahora'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
