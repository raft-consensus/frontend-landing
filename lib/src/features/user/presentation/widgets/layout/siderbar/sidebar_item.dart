// ==========================================
// Qué hace: Botón interactivo para cada ítem de navegación del sidebar (icono, texto e indicador activo).
// Dónde se conecta: Consumido por SidebarNavigationList.
// De dónde trae datos: Recibe el objeto SidebarItemData, bandera selected y callback onTap.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart';

/// Opción individual del menú de navegación lateral
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.item, // Datos de la opción (título e icono)
    required this.selected, // True si esta opción está activa
    required this.onTap, // Callback para cambiar la vista
    super.key,
  });

  final SidebarItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activePrimary = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final activeBg = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.12)
        : AppColors.dayPrimary.withValues(alpha: 0.08);
    final activeBorder = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.25)
        : AppColors.dayPrimary.withValues(alpha: 0.15);
    final inactiveColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    final textColor = selected ? activePrimary : inactiveColor;
    final iconColor = selected ? activePrimary : inactiveColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? activeBorder : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            // 1. Icono de la opción
            Icon(item.icon, size: 20, color: iconColor),
            const SizedBox(width: 12),

            // 2. Nombre de la sección
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            // 3. Indicador vertical derecho activo
            if (selected)
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: activePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
