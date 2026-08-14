// ==========================================
// Qué hace: Ensamblador principal limpio del panel lateral (Logo, Navegación, Plan y Perfil).
// Dónde se conecta: Renderizado en el lado izquierdo de DashboardPage y dentro del Drawer móvil.
// De dónde trae datos: Recibe selectedIndex y el callback onSelect.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_navigation_list.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_student_plan_card.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/siderbar/sidebar_user_profile.dart';

/// Panel lateral de navegación principal del Dashboard
class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({
    required this.selectedIndex, // Índice de la página activa
    required this.onSelect, // Callback al presionar una opción de menú
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
      width: 260, // Ancho estándar de 260px
      decoration: BoxDecoration(
        color: surfaceBg,
        border: Border(
          right: BorderSide(color: borderColor),
        ),
      ),
      child: Column(
        children: [
          // 1. Logotipo superior
          const Padding(
            padding: EdgeInsets.all(20),
            child: RaftLogo(),
          ),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 2. Lista de Navegación
          Expanded(
            child: SidebarNavigationList(
              selectedIndex: selectedIndex,
              onSelect: onSelect,
            ),
          ),

          // 3. Tarjeta de Uso / Plan Estudiante
          const SidebarStudentPlanCard(),

          const Divider(height: 1),

          // 4. Perfil de Usuario y Logout
          const Padding(
            padding: EdgeInsets.all(14),
            child: SidebarUserProfile(),
          ),
        ],
      ),
    );
  }
}
