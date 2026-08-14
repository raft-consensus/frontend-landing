// ==========================================
// Qué hace: Barra superior limpia de navegación que une los módulos de título, tema, notificaciones y servicios.
// Dónde se conecta: Se posiciona en la parte superior fija de DashboardPage.
// De dónde trae datos: Recibe title, onOpenDrawer, onCreateDatabase, onSelectTab y onMessage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/topbar/topbar_notifications_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/topbar/topbar_services_hub_button.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/topbar/topbar_theme_toggle.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/topbar/topbar_title_section.dart';

/// Barra superior fija de navegación del panel de usuario
class DashboardTopbar extends StatelessWidget {
  const DashboardTopbar({
    required this.title, // Título de la sección
    required this.onOpenDrawer, // Acción menú móvil
    required this.onCreateDatabase, // Acción crear BD
    this.onSelectTab, // Selector de pestaña activa
    this.onMessage, // Receptor de notificaciones
    super.key,
  });

  final String title;
  final VoidCallback onOpenDrawer;
  final VoidCallback onCreateDatabase;
  final ValueChanged<int>? onSelectTab;
  final void Function(String message, {bool success})? onMessage;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = isDark ? AppColors.nightSurface : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;

    return Container(
      height: 70, // Altura estándar
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        children: [
          // 1. Sección Izquierda (Título o Menú + Logo)
          TopbarTitleSection(
            title: title,
            isDesktop: isDesktop,
            onOpenDrawer: onOpenDrawer,
          ),

          const Spacer(),

          // 2. Conmutador de Tema Día / Noche
          const TopbarThemeToggle(),
          const SizedBox(width: 6),

          // 3. Notificaciones del Sistema
          const TopbarNotificationsButton(),
          const SizedBox(width: 10),

          // 4. Botón Ecosistema Raft (Hub de Servicios)
          TopbarServicesHubButton(
            isDesktop: isDesktop,
            onCreateDatabase: onCreateDatabase,
            onSelectTab: onSelectTab,
            onMessage: onMessage,
          ),
        ],
      ),
    );
  }
}
