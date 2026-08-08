import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Renderiza la balsa destacada en tamaño máximo vertical junto con la marca "Raft DB".
/// ¿De dónde trae datos?: Ingesta Theme.of(context).brightness y conmuta la imagen segun Raft Day / Raft Night.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en DashboardSidebar y DashboardTopbar.
class RaftLogo extends StatelessWidget {
  const RaftLogo({
    this.small = false, // Define si se dibuja en tamaño compacto (Topbar) o tamaño máximo (Sidebar)
    super.key,
  });

  final bool small;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta si el tema activo es oscuro (Raft Night)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // 2. Ruta exacta de la balsa según la paleta activa
    final logoPath = isDark ? 'lib/src/img/in/logo_night.png' : 'lib/src/img/in/logo_light.png';

    // 3. Colores dinámicos del texto "Raft DB"
    final raftTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Balsa isotipo maximizada verticalmente (58px en Sidebar)
        Image.asset(
          logoPath,
          height: small ? 45 : 65,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.sailing_rounded,
            color: raftTextColor,
            size: small ? 30 : 50,
          ),
        ),
        const SizedBox(width: 10),

        // Nombre de la marca "Raft DB" en tamaño prominente
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: small ? 25 : 30,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
            children: [
              TextSpan(
                text: 'Raft ',
                style: TextStyle(color: raftTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
