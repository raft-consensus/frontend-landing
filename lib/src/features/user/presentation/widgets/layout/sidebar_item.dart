import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart';

/// ¿Qué hace?: Botón interactivo para cada ítem de navegación del sidebar (ej: Resumen, Bases de datos).
/// ¿De dónde trae datos?: Recibe el objeto SidebarItemData desde DashboardSidebar y consulta Theme.of(context) para el color activo.
/// ¿Hacia dónde va / Cómo se conecta?: Renderiza la opción individual dentro del ListView en DashboardSidebar.
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.item,     // Datos de la opción (título e icono)
    required this.selected, // True si esta opción está activa actualmente
    required this.onTap,    // Callback para cambiar la vista al hacer clic
    super.key,
  });

  final SidebarItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // 1. Determina si el tema actual es oscuro (Raft Night) o claro (Raft Day)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Define el color primario según el tema (SkyBlue en Night, Navy en Day)
    final activePrimary = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;

    // 3. Define el fondo suave tintado cuando la opción está seleccionada
    final activeBg = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.12)
        : AppColors.dayPrimary.withValues(alpha: 0.08);

    // 4. Define el borde sutil de la opción activa
    final activeBorder = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.25)
        : AppColors.dayPrimary.withValues(alpha: 0.15);

    // 5. Color para icono y texto cuando la opción NO está seleccionada
    final inactiveColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return InkWell(
      onTap: onTap, // Acción al hacer clic
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180), // Transición suave de selección
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? activeBg : Colors.transparent, // Fondo tintado si está activo
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? activeBorder : Colors.transparent, // Borde tintado si está activo
          ),
        ),
        // Llama al sub-widget del contenido interno
        child: _SidebarItemContent(
          icon: item.icon,
          title: item.title,
          selected: selected,
          activeColor: activePrimary,
          inactiveColor: inactiveColor,
        ),
      ),
    );
  }
}

/// Sub-widget privado 1: Contenido interno de la fila (Icono + Texto + Indicador vertical)
class _SidebarItemContent extends StatelessWidget {
  const _SidebarItemContent({
    required this.icon,
    required this.title,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
  });

  final IconData icon;
  final String title;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;

  @override
  Widget build(BuildContext context) {
    // Selección dinámica del color de texto e icono
    final textColor = selected ? activeColor : inactiveColor;
    final iconColor = selected ? activeColor : inactiveColor;

    return Row(
      children: [
        // 1. Icono representativo de la opción
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),

        // 2. Texto con el nombre de la opción de menú
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),

        // 3. Píldora/indicador azul a la derecha sólo si está seleccionado
        if (selected) _SelectionIndicator(color: activeColor),
      ],
    );
  }
}

/// Sub-widget privado 2: Píldora/barra vertical azul a la derecha del ítem activo
class _SelectionIndicator extends StatelessWidget {
  const _SelectionIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 18,
      decoration: BoxDecoration(
        color: color, // Color primario activo
        borderRadius: BorderRadius.circular(4), // Bordes redondeados de la barra
      ),
    );
  }
}
