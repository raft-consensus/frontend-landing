// ==========================================
// Qué hace: Fila horizontal desplazable de filtros rápidos por estado (Activas/Pausadas) y motor (PostgreSQL, MySQL, etc).
// Dónde se conecta: Consumido por DatabaseToolbar.
// De dónde trae datos: Recibe selectedEngine, selectedStatus y callbacks de cambio.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Chips de filtrado por estado y motor
class DatabaseFilterChips extends StatelessWidget {
  const DatabaseFilterChips({
    required this.selectedEngine, // Motor seleccionado
    required this.selectedStatus, // Estado seleccionado
    required this.onEngineChanged, // Callback al cambiar motor
    required this.onStatusChanged, // Callback al cambiar estado
    super.key,
  });

  final String selectedEngine; // Motor activo
  final String selectedStatus; // Estado activo
  final ValueChanged<String> onEngineChanged; // Evento cambio de motor
  final ValueChanged<String> onStatusChanged; // Evento cambio de estado

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // 1. Grupo Estado (Todas, Activas, Pausadas)
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
                  color: isSelected ? Colors.white : (isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }),

          // Separador vertical
          Container(
            height: 24,
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: theme.dividerColor,
          ),

          // 2. Grupo Motor (Todos, PostgreSQL, MySQL, MongoDB, SQL Server)
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
                  color: isSelected ? theme.colorScheme.onPrimary : (isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary),
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }),
        ],
      ),
    );
  }
}
