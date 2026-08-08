import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Widget gráfico para estados vacíos cuando no hay bases de datos creadas o no hay resultados de búsqueda.
/// ¿De dónde trae datos?: Recibe callback onCreateDatabase y se adapta a los tokens de color del tema activo.
/// ¿Hacia dónde va / Cómo se conecta?: Se muestra dentro de DatabasesPage cuando la lista filtrada está vacía.
class EmptyDatabases extends StatelessWidget {
  const EmptyDatabases({
    required this.onCreateDatabase, // Callback para abrir el modal de crear BD
    super.key,
  });

  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono flotante circular con tono de acento
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.storage_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No hay bases de datos encontradas',
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Crea tu primera instancia de PostgreSQL, MySQL, MongoDB o SQL Server.',
            style: TextStyle(
              color: subtitleColor,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onCreateDatabase,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Crear instancia ahora'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
