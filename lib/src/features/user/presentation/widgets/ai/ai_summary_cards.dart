import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Muestra las 3 tarjetas de métricas KPI del servicio de IA con animación hover resplandeciente.
/// ¿De dónde trae datos?: Ingesta la lista o métricas de API Keys y detecta el tema activo (Raft Day / Raft Night).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la parte superior de AiServicesPage.
class AiSummaryCards extends StatelessWidget {
  const AiSummaryCards({
    required this.totalKeys,
    required this.totalRequests,
    super.key,
  });

  final int totalKeys; // Total de API Keys creadas por el usuario
  final int totalRequests; // Total de solicitudes consumidas entre todas las claves

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
                title: 'API Keys Activas',
                value: '$totalKeys / 10 Claves',
                subtitle: 'Límite máximo asignado',
                icon: Icons.vpn_key_rounded,
                iconColor: isDark ? AppColors.purple : AppColors.dayPrimary,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCard(
                title: 'Consumo Global Acumulado',
                value: '$totalRequests reqs',
                subtitle: 'Solicitudes procesadas por la IA',
                icon: Icons.data_usage_rounded,
                iconColor: AppColors.info,
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12),
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCard(
                title: 'Proveedor de Servicio IA',
                value: 'Célula Raft IA',
                subtitle: '10,000 solicitudes por clave',
                icon: Icons.auto_awesome_rounded,
                iconColor: AppColors.success,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Tarjeta interna Stateful para la micro-animación Hover
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
  bool _isHovered = false; // Estado del mouse sobre la tarjeta

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withValues(alpha: isDark ? 0.50 : 0.40)
                : theme.dividerColor,
          ),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: _isHovered ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(color: subtitleColor, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text(widget.value, style: TextStyle(color: titleColor, fontWeight: FontWeight.w900, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(widget.subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
