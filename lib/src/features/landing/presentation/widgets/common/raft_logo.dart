// ==========================================
// Archivo: lib/src/features/landing/presentation/widgets/common/raft_logo.dart
// ¿Qué hace?: Renderiza la balsa isotipo oficial desde assets con la marca "Raft Cloud" reactiva al tema.
// ¿De dónde trae datos?: Ingesta Theme.of(context).brightness para alternar entre logo_night.png y logo_light.png.
// ¿Hacia dónde va / Cómo se conecta?: Se incluye en NavigationBarSection, FooterSection y LandingDrawer.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

class RaftLogo extends StatelessWidget {
  const RaftLogo({
    this.light = false,
    this.small = false,
    super.key,
  });

  final bool light;
  final bool small;

  @override
  Widget build(BuildContext context) {
    // 1. Detecta tema visual (Raft Day vs Raft Night)
    final isDark = light || Theme.of(context).brightness == Brightness.dark;
    
    // 2. Ruta exacta de la balsa PNG según el tema activo
    final logoPath = isDark
        ? 'lib/src/img/in/logo_night.png'
        : 'lib/src/img/in/logo_light.png';
        
    final raftTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayPrimary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Isotipo balsa PNG oficial de la marca
        Image.asset(
          logoPath,
          height: small ? 35 : 45,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.sailing_rounded,
            color: AppColors.cyan,
            size: small ? 24 : 32,
          ),
        ),
        const SizedBox(width: 8),

        // Texto principal "Raft "
        Text(
          'Raft ',
          style: TextStyle(
            color: raftTextColor,
            fontSize: small ? 20 : 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),

        // Subtítulo de marca "Cloud"
        Text(
          'Cloud',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: small ? 20 : 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }
}
