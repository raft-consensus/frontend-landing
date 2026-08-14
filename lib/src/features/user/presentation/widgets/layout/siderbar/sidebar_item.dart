// ==========================================
// Que hace: Boton interactivo para cada item de navegacion del sidebar con control estricto de hover para evitar estados congelados.
// De donde trae datos: Recibe el objeto SidebarItemData, bandera selected y callback onTap.
// Donde se conecta: Consumido dentro de SidebarNavigationList.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart';

/// Opcion individual del menu de navegacion lateral con soporte para efectos Hover limpios
class SidebarItem extends StatefulWidget {
  const SidebarItem({
    required this.item, // Datos de la opcion (titulo e icono)
    required this.selected, // True si esta opcion esta activa
    required this.onTap, // Callback para cambiar la vista
    super.key,
  });

  final SidebarItemData item; // Metadata del elemento
  final bool selected; // Estado de seleccion actual
  final VoidCallback onTap; // Accion al presionar

  @override
  State<SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<SidebarItem> {
  bool _isHovered = false; // Estado reactivo de posicion del cursor

  @override
  void didUpdateWidget(covariant SidebarItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia la seleccion o pasa a estar seleccionado, resetea el hover para evitar que quede congelado
    if (oldWidget.selected != widget.selected || widget.selected) {
      _isHovered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 1. Paleta de colores para el estado Activo / Seleccionado
    final activePrimary = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final activeBg = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.14)
        : AppColors.dayPrimary.withValues(alpha: 0.09);
    final activeBorder = isDark
        ? AppColors.nightPrimary.withValues(alpha: 0.30)
        : AppColors.dayPrimary.withValues(alpha: 0.18);

    // 2. Paleta de colores para el estado Hover (cursor encima pero no activo)
    final hoverBg = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : AppColors.dayPrimary.withValues(alpha: 0.04);
    final hoverBorder = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : AppColors.dayPrimary.withValues(alpha: 0.10);

    // 3. Paleta para el estado Inactivo estandar
    final inactiveTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final hoverTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    // 4. Resolucion final de colores segun el estado
    Color containerBg = Colors.transparent;
    Color containerBorder = Colors.transparent;
    Color iconAndTextColor = inactiveTextColor;

    if (widget.selected) {
      containerBg = activeBg;
      containerBorder = activeBorder;
      iconAndTextColor = activePrimary;
    } else if (_isHovered) {
      containerBg = hoverBg;
      containerBorder = hoverBorder;
      iconAndTextColor = hoverTextColor;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          setState(() => _isHovered = false);
          widget.onTap();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            color: containerBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: containerBorder),
          ),
          child: Row(
            children: [
              // 1. Icono de la opcion
              Icon(
                widget.item.icon,
                size: 20,
                color: iconAndTextColor,
              ),
              const SizedBox(width: 12),

              // 2. Nombre de la seccion
              Expanded(
                child: Text(
                  widget.item.title,
                  style: TextStyle(
                    color: iconAndTextColor,
                    fontWeight: widget.selected ? FontWeight.w800 : (_isHovered ? FontWeight.w700 : FontWeight.w500),
                    fontSize: 13,
                  ),
                ),
              ),

              // 3. Indicador vertical derecho activo
              if (widget.selected)
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
      ),
    );
  }
}
