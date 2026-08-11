// ==========================================
// Qué hace: Widget reutilizable con buscador y filtros combinados por Motor y Estado de la BD.
// Dónde se conecta: Se incluye en DatabasesPage.
// De dónde trae datos: Recibe el estado actual (selectedEngine, selectedStatus) y callbacks.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// Barra de búsqueda y chips de filtrado dual (por motor y por estado activo/pausado)
class DatabaseSearchFilter extends StatelessWidget {
  const DatabaseSearchFilter({
    required this.selectedEngine, // Motor seleccionado ('Todos', 'PostgreSQL', etc.)
    required this.selectedStatus, // Estado seleccionado ('Todas', 'Activas', 'Pausadas')
    required this.onSearchChanged, // Callback al escribir en la barra de búsqueda
    required this.onEngineChanged, // Callback al presionar un chip de motor
    required this.onStatusChanged, // Callback al presionar un chip de estado
    super.key,
  });

  final String selectedEngine;
  final String selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onEngineChanged;
  final ValueChanged<String> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Campo de Búsqueda por texto
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

        // 2. Fila de Filtros (Estado y Motores)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Grupo A: Filtros por Estado (Todas, Activas, Pausadas)
              ...['Todas', 'Activas', 'Pausadas'].map((status) {
                final isSelected = selectedStatus == status;
                Color badgeColor = theme.colorScheme.primary;
                if (status == 'Activas') badgeColor = AppColors.success;
                if (status == 'Pausadas') badgeColor = AppColors.warning;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    avatar: status != 'Todas'
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : badgeColor,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                    label: Text(status),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onStatusChanged(status);
                    },
                    selectedColor: badgeColor,
                    backgroundColor: theme.cardColor,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary),
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                      fontSize: 12,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }),

              // Separador vertical entre filtros de Estado y Motor
              Container(
                height: 24,
                width: 1,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: theme.dividerColor,
              ),

              // Grupo B: Filtros por Motor (Todos, PostgreSQL, MySQL, MongoDB, SQL Server)
              ...['Todos', 'PostgreSQL', 'MySQL', 'MongoDB', 'SQL Server'].map((engine) {
                final isSelected = selectedEngine == engine;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(engine),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) onEngineChanged(engine);
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
              }),
            ],
          ),
        ),
      ],
    );
  }
}
