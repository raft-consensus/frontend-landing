import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Trae AppColors de core
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart'; // Trae SidebarItemData de domain

/// ¿Qué hace?: Botón gráfico individual para cada ítem de menú de la barra lateral con estado seleccionado.
/// ¿De dónde trae?: Trae AppColors (core) y SidebarItemData (domain/entities).
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de DashboardSidebar para generar la lista de navegación.
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    required this.item,       // Objeto de datos del ítem (título e icono)
    required this.selected,   // Booleano: true si esta pestaña está activa en pantalla
    required this.onTap,      // Acción al presionar el botón de menú
    super.key,
  });

  final SidebarItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Botón interactivo clickeable (InkWell)
    return InkWell(
      onTap: onTap, // Dispara el cambio de vista en DashboardPage
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.blue.withOpacity(0.10) : Colors.transparent, // Fondo azul pastel si está activo
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.blue.withOpacity(0.20) : Colors.transparent, // Borde fino si está activo
          ),
        ),
        child: Row(
          children: [
            // Icono de la opción
            Icon(
              item.icon,
              size: 20,
              color: selected ? AppColors.blue : AppColors.muted, // Azul brillante si activo, gris si inactivo
            ),
            const SizedBox(width: 12),
            // Nombre de la opción (ej. "Resumen", "Bases de datos")
            Expanded(
              child: Text(
                item.title,
                style: TextStyle(
                  color: selected ? AppColors.blue : AppColors.text, // Texto destacado si activo
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            // Indicador de barra azul vertical a la derecha si está seleccionado
            if (selected)
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
