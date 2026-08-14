// ==========================================
// Qué hace: Tarjeta explicativa sobre Cloudflare DNS, certificados SSL automáticos y Direct TCP.
// Dónde se conecta: Renderizado al pie de DnsSslPage.
// De dónde trae datos: Se adapta al tema activo.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Tarjeta informativa inferior sobre la infraestructura de Dominio & SSL
class DnsInfoCard extends StatelessWidget {
  const DnsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: isDark ? 0.08 : 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withValues(alpha: isDark ? 0.30 : 0.25),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, color: primaryColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Infraestructura DNS & SSL Gestionada',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Los subdominios creados se propagan automáticamente en los servidores perimetrales de Cloudflare. '
                  'Cuentan con certificados SSL/TLS universales y enrutamiento TCP directo para conectividad con tus bases de datos.',
                  style: TextStyle(color: subtitleColor, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
