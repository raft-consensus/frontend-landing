// ==========================================
// Qué hace: Insignias atómicas Direct TCP (proxied: false) y SSL Activo.
// Dónde se conecta: Consumido en las filas de subdominios en escritorio y móvil.
// De dónde trae datos: Se adapta al tema activo.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Insignia que indica conexión Direct TCP requerida para bases de datos
class DirectTcpBadge extends StatelessWidget {
  const DirectTcpBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = AppColors.warning;

    return Tooltip(
      message: 'proxied: false (Conexión TCP directa requerida para BD)',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: warningColor.withValues(alpha: isDark ? 0.18 : 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: warningColor.withValues(alpha: isDark ? 0.40 : 0.60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 12, color: warningColor),
            const SizedBox(width: 4),
            Text(
              'Direct TCP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Insignia que indica certificado SSL Activo en Cloudflare
class SslBadge extends StatelessWidget {
  const SslBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: successColor.withValues(alpha: isDark ? 0.40 : 0.60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock_outline_rounded, size: 12, color: successColor),
          const SizedBox(width: 4),
          Text(
            'SSL Activo',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: successColor,
            ),
          ),
        ],
      ),
    );
  }
}
