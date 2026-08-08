import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Insignia o píldora de tecnología/motor con icono o imagen corta para acompañar las tarjetas de servicios.
/// ¿De dónde trae datos?: Ingesta la etiqueta textual String label y opcionalmente String assetPath o IconData icon.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro del listado inferior en DatabaseCard.
class ServiceTechBadge extends StatelessWidget {
  const ServiceTechBadge({
    required this.label, // Nombre de la tecnología o subservicio
    this.assetPath, // Ruta de imagen opcional (ej: lib/src/img/in/mysql.png)
    this.icon, // Icono opcional si no hay imagen asset
    this.color, // Color del icono o tinte
    super.key,
  });

  final String label;
  final String? assetPath;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final badgeBg = isDark
        ? AppColors.nightBackground.withValues(alpha: 0.6)
        : AppColors.dayBackground; // Fondo dinámico
    final badgeBorder = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde dinámico
    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Texto dinámico

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Padding compacto
      decoration: BoxDecoration(
        color: badgeBg,
        borderRadius: BorderRadius.circular(8), // Esquinas ligeramente redondeadas
        border: Border.all(color: badgeBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assetPath != null)
            Image.asset(assetPath!, width: 14, height: 14, fit: BoxFit.contain)
          else if (icon != null)
            Icon(icon, size: 14, color: color ?? AppColors.cyan),
          if (assetPath != null || icon != null) const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
