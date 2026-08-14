// ==========================================
// Qué hace: Fila responsiva superior que organiza las 3 tarjetas de métricas DNS.
// Dónde se conecta: Renderizado en la parte superior de DnsSslPage.
// De dónde trae datos: Ingesta el totalRecords desde Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/summary/dns_metric_card.dart';

/// Fila responsiva de tarjetas métricas de Dominio y SSL
class DnsSummaryCards extends StatelessWidget {
  const DnsSummaryCards({
    required this.totalRecords, // Total de registros DNS asignados
    super.key,
  });

  final int totalRecords; // Conteo de subdominios

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 750;

        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical,
          children: [
            // 1. Zona Activa Cloudflare
            Expanded(
              flex: isWide ? 1 : 0,
              child: DnsMetricCard(
                value: 'coderhivex.com',
                title: 'Zona Activa Cloudflare',
                icon: Icons.language_rounded,
                iconColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 2. Certificado SSL
            Expanded(
              flex: isWide ? 1 : 0,
              child: const DnsMetricCard(
                value: '*.coderhivex.com',
                title: 'Certificado SSL Universal',
                icon: Icons.verified_user_rounded,
                iconColor: AppColors.success,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),

            // 3. Subdominios Asignados
            Expanded(
              flex: isWide ? 1 : 0,
              child: DnsMetricCard(
                value: '$totalRecords Subdominios',
                title: 'Registros DNS Asignados',
                icon: Icons.dns_rounded,
                iconColor: isDark ? AppColors.nightSecondary : AppColors.daySecondary,
              ),
            ),
          ],
        );
      },
    );
  }
}
