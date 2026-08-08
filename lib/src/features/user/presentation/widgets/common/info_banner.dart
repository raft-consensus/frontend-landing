import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Banner decorativo responsivo para mostrar avisos informativos o alertas con soporte Día/Noche.
/// ¿De dónde trae datos?: Ingesta mensaje, icono y se adapta dinámicamente al tema de la aplicación.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa en CreateDatabaseDialog, CredentialsDialog, etc.
class InfoBanner extends StatelessWidget {
  const InfoBanner({
    required this.message,
    required this.icon,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.textColor,
    super.key,
  });

  final String message;
  final IconData icon;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveIconColor = iconColor ?? theme.colorScheme.primary;
    final defaultBg = effectiveIconColor.withValues(alpha: isDark ? 0.15 : 0.08);
    final defaultBorder = effectiveIconColor.withValues(alpha: isDark ? 0.35 : 0.20);
    final defaultText = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: backgroundColor ?? defaultBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: borderColor ?? defaultBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: effectiveIconColor, size: 20),
          const SizedBox(width: 11),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor ?? defaultText,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
