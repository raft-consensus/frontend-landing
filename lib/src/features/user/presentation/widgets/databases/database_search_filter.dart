import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Widget reutilizable con la barra de búsqueda y los chips de filtro por motor de BD.
/// ¿De dónde trae datos?: Recibe el estado actual y callbacks desde DatabasesPage.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en DatabasesPage.
class DatabaseSearchFilter extends StatelessWidget {
  const DatabaseSearchFilter({
    required this.selectedEngine,
    required this.onSearchChanged,
    required this.onEngineChanged,
    super.key,
  });

  final String selectedEngine; // Motor actualmente seleccionado ('Todos', 'PostgreSQL', etc.)
  final ValueChanged<String> onSearchChanged; // Callback al escribir en el buscador
  final ValueChanged<String> onEngineChanged; // Callback al presionar un chip

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Buscador
        TextField(
          onChanged: onSearchChanged,
          style: TextStyle(
            color: isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary,
            fontSize: 13,
          ),
          decoration: InputDecoration(
            hintText: 'Buscar por nombre, host o base de datos...',
            hintStyle: TextStyle(
              color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: 20,
              color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
            ),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Chips de Filtro
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todos', 'PostgreSQL', 'MySQL', 'MongoDB', 'SQL Server'].map((filter) {
              final isSelected = selectedEngine == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(filter),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) onEngineChanged(filter);
                  },
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: theme.cardColor,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : (isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary),
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
