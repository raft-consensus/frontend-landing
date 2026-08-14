// ==========================================
// Qué hace: Sección izquierda de la barra superior. En móvil muestra menú hamburguesa y logo; en escritorio el título.
// Dónde se conecta: Consumido por DashboardTopbar.
// De dónde trae datos: Recibe title, isDesktop y el callback onOpenDrawer.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';

/// Sección de título y navegación móvil de la barra superior
class TopbarTitleSection extends StatelessWidget {
  const TopbarTitleSection({
    required this.title, // Título de la pestaña activa
    required this.isDesktop, // Bandera de ancho de pantalla escritorio
    required this.onOpenDrawer, // Callback para abrir drawer móvil
    super.key,
  });

  final String title;
  final bool isDesktop;
  final VoidCallback onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    if (!isDesktop) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onOpenDrawer,
            icon: Icon(Icons.menu_rounded, color: iconColor),
            tooltip: 'Abrir menú de navegación',
          ),
          const SizedBox(width: 8),
          const RaftLogo(small: true),
        ],
      );
    }

    return Text(
      title,
      style: TextStyle(
        color: titleColor,
        fontSize: 20,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}
