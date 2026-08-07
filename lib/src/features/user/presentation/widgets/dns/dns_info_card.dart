import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Tarjeta informativa al pie de la página con detalles técnicos de la integración Cloudflare y SSL.
/// ¿De dónde trae?: Consume AppColors de core/theme y detecta el tema del sistema.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye al final del cuerpo principal en DnsSslPage.
class DnsInfoCard extends StatelessWidget {
  const DnsInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.border,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: AppColors.blue,
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuracion Tecnica de DNS & Certificados SSL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '• Los registros A se aprovisionan automaticamente con "proxied: false" en Cloudflare para permitir la conectividad directa TCP a tus bases de datos.\n'
                  '• El certificado SSL Universal Wildcard (*.coderhivex.com) protege automaticamente todos tus subdominios sin necesidad de subir certificados manualmente.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
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
