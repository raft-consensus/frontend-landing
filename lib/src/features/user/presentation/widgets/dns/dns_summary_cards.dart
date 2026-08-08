import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Renderiza las 3 tarjetas de resumen KPI en la parte superior con animación hover resplandeciente según el tema.
/// ¿De dónde trae datos?: Recibe el conteo total de registros DNS y detecta el tema del sistema.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye en la parte superior de DnsSslPage.
class DnsSummaryCards extends StatelessWidget {
  const DnsSummaryCards({
    required this.totalRecords,
    super.key,
  });

  final int totalRecords;

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
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCard(
                title: 'Zona Activa Cloudflare',
                value: 'coderhivex.com',
                subtitle: 'Zone ID: c1c62663...03e6e83',
                icon: Icons.language_rounded,
                iconColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(
              width: isWide ? 16 : 0,
              height: isWide ? 0 : 12,
            ),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCard(
                title: 'Certificado SSL Universal',
                value: '*.coderhivex.com',
                subtitle: 'TLS 1.3 Cobertura 100%',
                icon: Icons.verified_user_rounded,
                iconColor: AppColors.success,
              ),
            ),
            SizedBox(
              width: isWide ? 16 : 0,
              height: isWide ? 0 : 12,
            ),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCard(
                title: 'Registros DNS Asignados',
                value: '$totalRecords Subdominios',
                subtitle: 'Tipo A / Sin Proxy (Direct TCP)',
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

/// Widget interno Stateful para controlar la micro-animación Hover de cada tarjeta
class _MetricCard extends StatefulWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  State<_MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<_MetricCard> {
  // 1. Estado local que rastrea si el mouse está sobre la tarjeta
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    // 2. MouseRegion detecta las entradas y salidas del cursor
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Transición fluida de 200ms
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          // 3. Borde iluminado con el color del icono al hacer hover
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withValues(alpha: isDark ? 0.50 : 0.40)
                : theme.dividerColor,
          ),
          // 4. Sombra resplandeciente flotante
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.iconColor.withValues(alpha: isDark ? 0.20 : 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icono contenido en contenedor dinámico
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: _isHovered ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                widget.icon,
                color: widget.iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: titleColor,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
