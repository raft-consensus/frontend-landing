// ==========================================
// Qué hace: Lista vertical desplazable con las 7 opciones principales del menú de navegación.
// Dónde se conecta: Consumido dentro de DashboardSidebar.
// De dónde trae datos: Recibe el selectedIndex y callback onSelect.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_item.dart';

/// Lista vertical de opciones de menú del panel de usuario
class SidebarNavigationList extends StatelessWidget {
  const SidebarNavigationList({
    required this.selectedIndex, // Índice activo
    required this.onSelect, // Callback de cambio
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  // Catálogo de secciones del menú
  static const List<SidebarItemData> menuItems = [
    SidebarItemData(title: 'Resumen', icon: Icons.grid_view_rounded),
    SidebarItemData(title: 'Bases de datos', icon: Icons.storage_rounded),
    SidebarItemData(title: 'DNS & SSL', icon: Icons.language_rounded),
    SidebarItemData(title: 'Servicio de IA', icon: Icons.auto_awesome_rounded),
    SidebarItemData(title: 'Workflows (n8n)', icon: Icons.hub_rounded),
    SidebarItemData(title: 'Guías', icon: Icons.menu_book_rounded ),
    SidebarItemData(title: 'Mi cuenta', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: SidebarItem(
            item: item,
            selected: selectedIndex == index,
            onTap: () => onSelect(index),
          ),
        );
      },
    );
  }
}
