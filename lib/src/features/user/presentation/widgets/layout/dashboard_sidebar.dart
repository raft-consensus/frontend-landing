import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/sidebar_item_data.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/sidebar_item.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/sidebar_user.dart';

/// ¿Qué hace?: Panel lateral de navegación completo con el logo, opciones de menú, widget de consumo de plan y tarjeta de usuario.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) para adaptar fondos y bordes entre Raft Day y Raft Night.
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica a la izquierda en DashboardPage (desktop) o dentro del Drawer (móvil).
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex, // Índice de la página actualmente activa
    required this.onSelect,      // Callback al presionar una opción de menú
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  // Lista de las 5 opciones de navegación principal
  final List<SidebarItemData> _menuItems = const [
    SidebarItemData(title: 'Resumen', icon: Icons.grid_view_rounded),
    SidebarItemData(title: 'Bases de datos', icon: Icons.dns_rounded),
    SidebarItemData(title: 'Dominio & SSL', icon: Icons.lan_rounded),
    SidebarItemData(title: 'Herramientas y Guías', icon: Icons.handyman_rounded),
    SidebarItemData(title: 'Mi cuenta', icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si el tema activo es oscuro (Raft Night)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Selecciona los colores de superficie y borde lateral según la paleta activa
    final surfaceBg = isDark ? AppColors.nightSurface : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;

    return Container(
      width: 260, // Ancho fijo del sidebar en escritorio
      decoration: BoxDecoration(
        color: surfaceBg,
        border: Border(
          right: BorderSide(color: borderColor), // Línea divisoria derecha
        ),
      ),
      child: Column(
        children: [
          // 1. Logotipo superior dinámico (RaftLogo)
          const Padding(
            padding: EdgeInsets.all(20),
            child: RaftLogo(),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 2. Lista vertical scrolleable de opciones del menú (SidebarItem)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: _menuItems.length,
              itemBuilder: (context, index) {
                final item = _menuItems[index];

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

          // 3. Tarjeta de consumo de recursos "Plan Estudiante" (Sub-widget desacoplado)
          const _StudentPlanCard(),

          const Divider(height: 1),

          // 4. Perfil de usuario en el pie del sidebar (SidebarUser)
          const Padding(
            padding: EdgeInsets.all(14),
            child: SidebarUser(),
          ),
        ],
      ),
    );
  }
}

/// Sub-widget privado: Tarjeta con indicador visual de consumo de cuota "Plan Estudiante"
class _StudentPlanCard extends StatelessWidget {
  const _StudentPlanCard();

  @override
  Widget build(BuildContext context) {
    // Detecta el tema para adaptar el contenedor de la cuota
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Colores dinámicos para Raft Day vs Raft Night
    final cardBg = isDark
        ? AppColors.nightCard.withValues(alpha: 0.6)
        : const Color(0xFFF0F7FF);
    final borderColor = isDark ? AppColors.nightBorder : const Color(0xFFD4E8FC);
    final primaryTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary;
    final secondaryTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final progressColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final progressBgColor = isDark ? const Color(0xFF28465F) : const Color(0xFFD4E8FC);

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado: Icono + Título del Plan
          Row(
            children: [
              Icon(
                Icons.school_outlined, // Icono distintivo de estudiante
                size: 16,
                color: progressColor,
              ),
              const SizedBox(width: 6),
              Text(
                'Plan Estudiante',
                style: TextStyle(
                  color: primaryTextColor,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Texto informativo del uso de almacenamiento
          Text(
            'Uso de recursos: 326 MB / 512 MB',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 6),

          // Barra gráfica de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.63, // 63% consumido
              backgroundColor: progressBgColor,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
