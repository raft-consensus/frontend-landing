// ==========================================
// Que hace: Ensamblador principal del panel lateral compacto (228px) con isotipo destacado, navegacion y telemetria.
// De donde trae datos: Recibe selectedIndex y el callback onSelect.
// Donde se conecta: Renderizado en el lado izquierdo de DashboardPage y dentro del Drawer movil.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_navigation_list.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_student_plan_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_user_profile.dart';

/// Panel lateral de navegacion principal del Dashboard
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex, // Indice de la pagina activa
    required this.onSelect, // Callback al presionar una opcion de menu
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceBg = isDark ? AppColors.nightSurface : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;

    return Container(
      width: 228, // Ancho compacto y estilizado
      decoration: BoxDecoration(
        color: surfaceBg,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          // 1. Isotipo superior con protagonismo y espaciado holgado
          const Padding(
            padding: EdgeInsets.only(top: 28, bottom: 22),
            child: RaftLogo(iconOnly: true),
          ),
          const SizedBox(height: 8),

          // 2. Lista de Navegacion
          Expanded(
            child: SidebarNavigationList(
              selectedIndex: selectedIndex,
              onSelect: onSelect,
            ),
          ),

          // 3. Tarjeta de Resumen del Plan Desarrollador
          const SidebarStudentPlanCard(),

          Divider(color: borderColor, height: 1),

          // 4. Perfil de Usuario y Logout
          const Padding(
            padding: EdgeInsets.all(12),
            child: SidebarUserProfile(),
          ),
        ],
      ),
    );
  }
}
