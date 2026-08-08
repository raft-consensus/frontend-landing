import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Tarjeta informativa al pie de la página con detalles técnicos de la integración Cloudflare y SSL.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) y AppColors.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye al final del cuerpo principal en DnsSslPage.
class DnsInfoCard extends StatelessWidget {
  const DnsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuracion Tecnica de DNS & Certificados SSL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '• Los registros A se aprovisionan automaticamente con "proxied: false" en Cloudflare para permitir la conectividad directa TCP a tus bases de datos.\n'
                  '• El certificado SSL Universal Wildcard (*.coderhivex.com) protege automaticamente todos tus subdominios sin necesidad de subir certificados manualmente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: subtitleColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
