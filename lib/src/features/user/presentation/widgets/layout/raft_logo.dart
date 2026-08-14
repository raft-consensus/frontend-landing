// ==========================================
// Que hace: Renderiza el isotipo y nombre de marca Raft Cloud con opcion de solo icono destacado de 64px para el Sidebar.
// De donde trae datos: Ingesta Theme.of(context).brightness y conmuta el logo segun tema claro/oscuro.
// Donde se conecta: Consumido en DashboardSidebar y DashboardTopbar.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de marca y logotipo oficial de Raft Cloud
class RaftLogo extends StatelessWidget {
  const RaftLogo({
    this.small = false, // Modo compacto para barras estrechas
    this.iconOnly = false, // Dibuja exclusivamente la balsa con alto protagonismo
    super.key,
  });

  final bool small; // Bandera para tamano reducido
  final bool iconOnly; // Bandera para solo isotipo

  @override
  Widget build(BuildContext context) {
    // 1. Deteccion de tema activo
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 2. Ruta del asset segun la paleta activa
    final logoPath = isDark ? 'lib/src/img/in/logo_night.png' : 'lib/src/img/in/logo_light.png';

    // 3. Color del texto o icono de respaldo
    final raftTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary;

    // Isotipo de la balsa con dimensiones destacadas
    final imageWidget = Image.asset(
      logoPath,
      height: small ? 32 : (iconOnly ? 64 : 46),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Icon(
        Icons.sailing_rounded,
        color: raftTextColor,
        size: small ? 26 : (iconOnly ? 54 : 36),
      ),
    );

    // Si solo se solicita el isotipo (Sidebar moderno)
    if (iconOnly) {
      return Center(child: imageWidget);
    }

    // Disposicion horizontal con texto
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        imageWidget,
        const SizedBox(width: 8),
        Text(
          'Raft Cloud',
          style: TextStyle(
            fontSize: small ? 18 : 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: raftTextColor,
          ),
        ),
      ],
    );
  }
}
