import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart'; // Layout
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/sidebar_item.dart'; // Layout
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/sidebar_user.dart'; // Layout

/// ¿Qué hace?: Panel lateral de navegación completo con el logo, lista de ítems de menú, tarjeta de consumo del plan y usuario.
/// ¿De dónde trae?: Trae AppColors (core), SidebarItemData (domain), RaftLogo, SidebarItem y SidebarUser (layout).
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica a la izquierda en DashboardPage (desktop) o dentro del Drawer (móvil).
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex, // Índice de la página actualmente activa
    required this.onSelect,       // Callback al hacer clic en una opción de menú
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  // Lista de las 5 opciones de menú principal del usuario
  final List<SidebarItemData> _menuItems = const [
    SidebarItemData(title: 'Resumen', icon: Icons.grid_view_rounded),
    SidebarItemData(title: 'Bases de datos', icon: Icons.dns_rounded),
    SidebarItemData(title: 'Herramientas', icon: Icons.build_circle_outlined),
    SidebarItemData(title: 'Documentación', icon: Icons.description_outlined),
    SidebarItemData(title: 'Mi cuenta', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260, // Ancho fijo del sidebar de 260px
      decoration: const BoxDecoration(
        color: Colors.white, // Fondo blanco plano
        border: Border(
          right: BorderSide(color: AppColors.border), // Borde derecho separador
        ),
      ),
      child: Column(
        children: [
          // Logo superior (RaftLogo)
          const Padding(
            padding: EdgeInsets.all(20),
            child: RaftLogo(),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Lista vertical scrolleable de opciones del menú
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];

                // Usa el widget de ítem de layout extraído SidebarItem
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: SidebarItem(
                    item: item,
                    selected: selectedIndex == index,
                    onTap: () => onSelect(index),
                  ),
                );
              },
            ),
          ),

          // Tarjeta azul de estado de cuota "Plan Estudiante"
          Container(
            margin: const EdgeInsets.all(14),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F7FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFD4E8FC)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.workspace_premium_rounded, size: 16, color: AppColors.blue),
                    SizedBox(width: 6),
                    Text(
                      'Plan Estudiante',
                      style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Uso de recursos: 326 MB / 512 MB', style: TextStyle(color: AppColors.muted, fontSize: 10)),
                const SizedBox(height: 6),
                // Barra gráfica de progreso azul
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: const LinearProgressIndicator(
                    value: 0.63, // 63% consumido
                    backgroundColor: Color(0xFFD4E8FC),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          // Tarjeta de perfil de usuario al pie (SidebarUser)
          const Padding(
            padding: EdgeInsets.all(14),
            child: SidebarUser(),
          ),
        ],
      ),
    );
  }
}
