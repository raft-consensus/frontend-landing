import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Renderiza las 3 tarjetas de resumen KPI en la parte superior (Zona, SSL Universal, Subdominios).
/// ¿De dónde trae?: Recibe el conteo total de registros DNS y detecta el tema claro/oscuro del sistema.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en la parte superior de DnsSslPage.
class DnsSummaryCards extends StatelessWidget {
  const DnsSummaryCards({
    required this.totalRecords,
    super.key,
  });

  final int totalRecords;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 750;
        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            Expanded(
              flex: isWide ? 1 : 0,
              child: _buildMetricCard(
                context: context,
                isDark: isDark,
                title: 'Zona Activa Cloudflare',
                value: 'coderhivex.com',
                subtitle: 'Zone ID: c1c62663...03e6e83',
                icon: Icons.language_rounded,
                iconColor: AppColors.blue,
              ),
            ),
            SizedBox(
              width: isWide ? 16 : 0,
              height: isWide ? 0 : 12,
            ),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _buildMetricCard(
                context: context,
                isDark: isDark,
                title: 'Certificado SSL Universal',
                value: '*.coderhivex.com',
                subtitle: 'TLS 1.3 Cobertura 100%',
                icon: Icons.verified_user_rounded,
                iconColor: Colors.green,
              ),
            ),
            SizedBox(
              width: isWide ? 16 : 0,
              height: isWide ? 0 : 12,
            ),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _buildMetricCard(
                context: context,
                isDark: isDark,
                title: 'Registros DNS Asignados',
                value: '$totalRecords Subdominios',
                subtitle: 'Tipo A / Sin Proxy (Direct TCP)',
                icon: Icons.dns_rounded,
                iconColor: AppColors.navy,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Tarjeta de métrica individual formateada
  Widget _buildMetricCard({
    required BuildContext context,
    required bool isDark,
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark ? Colors.grey[400] : AppColors.muted,
                    fontSize: 11,
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
