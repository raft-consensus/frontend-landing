// ==========================================
// Que hace: Seccion izquierda de la barra superior con soporte para vista compacta (<500px), intermedia (500-899px) y escritorio (>=900px).
// De donde trae datos: Recibe title, isDesktop y el callback onOpenDrawer.
// Donde se conecta: Consumido dentro de DashboardTopbar.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';

/// Seccion de navegacion contextual adaptable segun el ancho de pantalla
class TopbarTitleSection extends StatelessWidget {
  const TopbarTitleSection({
    required this.title, // Titulo de la pestana activa
    required this.isDesktop, // Bandera de ancho de pantalla escritorio (>= 900px)
    required this.onOpenDrawer, // Callback para abrir drawer movil
    super.key,
  });

  final String title;
  final bool isDesktop;
  final VoidCallback onOpenDrawer;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final parentColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final activeColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    // 1. Pantallas no-escritorio (< 900px)
    if (!isDesktop) {
      final isVeryCompact = screenWidth < 500; // Moviles estrechos (< 500px)

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onOpenDrawer,
            icon: Icon(Icons.menu_rounded, color: iconColor),
            tooltip: 'Abrir menú de navegación',
          ),
          const SizedBox(width: 6),
          // En moviles estrechos (<500px) solo balsa; en tablets/pantallas intermedias (500-899px) balsa + "Raft Cloud"
          RaftLogo(small: true, iconOnly: isVeryCompact),
        ],
      );
    }

    // 2. Pantallas de escritorio (>= 900px): Migas de pan (Breadcrumbs) completas
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.grid_view_rounded,
          size: 17,
          color: parentColor.withValues(alpha: 0.85),
        ),
        const SizedBox(width: 8),
        Text(
          'Raft Cloud',
          style: TextStyle(
            color: parentColor,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          Icons.chevron_right_rounded,
          size: 18,
          color: parentColor.withValues(alpha: 0.60),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: activeColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
