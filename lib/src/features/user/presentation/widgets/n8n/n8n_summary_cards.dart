import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Muestra 3 tarjetas KPI con métricas del servicio n8n y micro-animación al pasar el cursor (Hover).
/// ¿De dónde trae datos?: Ingesta estado del servicio, flujos activos, ejecuciones del mes y detecta el tema activo (Day/Night).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la parte superior de N8nServicesPage.
class N8nSummaryCards extends StatelessWidget {
  final String serviceStatus;      // Estado de la conexión ("ACTIVE", "INACTIVE")
  final int activeWorkflows;       // Cantidad de flujos activos
  final int maxWorkflows;          // Límite máximo de flujos permitidos
  final int monthlyExecutions;     // Consumo mensual de ejecuciones
  final int maxMonthlyExecutions;  // Límite mensual permitido

  const N8nSummaryCards({
    required this.serviceStatus,      // Parámetro requerido
    required this.activeWorkflows,      // Parámetro requerido
    required this.maxWorkflows,         // Parámetro requerido
    required this.monthlyExecutions,    // Parámetro requerido
    required this.maxMonthlyExecutions, // Parámetro requerido
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo de la aplicación
    final isDark = theme.brightness == Brightness.dark; // Booleano: true si el modo noche está activo

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 750; // Detecta si la pantalla tiene ancho de escritorio

        return Flex(
          direction: isWide ? Axis.horizontal : Axis.vertical, // Alineación horizontal en desktop, vertical en móvil
          children: [
            // 1. Tarjeta KPI 1: Estado del servicio
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCardItem(
                title: 'Estado del Servicio',                            // Título de la tarjeta
                value: serviceStatus == 'ACTIVE' ? 'Conectado' : 'Fuera de Línea', // Texto del estado
                subtitle: 'Célula n8n Externa',                          // Subtítulo
                icon: Icons.hub_rounded,                                // Icono representativo
                iconColor: AppColors.success,                           // Color verde éxito
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12), // Espaciado adaptativo

            // 2. Tarjeta KPI 2: Flujos activos
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCardItem(
                title: 'Flujos Activos',                                // Título de la tarjeta
                value: '$activeWorkflows / $maxWorkflows Flujos',       // Valor formateado
                subtitle: 'Cuota asignada por célula',                  // Subtítulo
                icon: Icons.account_tree_rounded,                       // Icono representativo
                iconColor: isDark ? AppColors.purple : AppColors.dayPrimary, // Color morado/azul según tema
              ),
            ),
            SizedBox(width: isWide ? 16 : 0, height: isWide ? 0 : 12), // Espaciado adaptativo

            // 3. Tarjeta KPI 3: Ejecuciones mensuales
            Expanded(
              flex: isWide ? 1 : 0,
              child: _MetricCardItem(
                title: 'Ejecuciones del Mes',                           // Título de la tarjeta
                value: '$monthlyExecutions / $maxMonthlyExecutions',    // Valor de ejecuciones
                subtitle: 'Restablecimiento mensual',                   // Subtítulo
                icon: Icons.speed_rounded,                              // Icono representativo
                iconColor: AppColors.info,                              // Color azul informativo
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Widget privado que representa cada tarjeta métrica individual con efecto Hover resplandeciente
class _MetricCardItem extends StatefulWidget {
  final String title;     // Título del indicador
  final String value;     // Valor numérico o texto principal
  final String subtitle;  // Texto secundario aclaratorio
  final IconData icon;    // Icono del indicador
  final Color iconColor;  // Color del icono y borde hover

  const _MetricCardItem({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<_MetricCardItem> createState() => _MetricCardItemState();
}

class _MetricCardItemState extends State<_MetricCardItem> {
  bool _isHovered = false; // Variable de estado para controlar cuando el cursor pasa por encima

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Objeto con el tema global
    final isDark = theme.brightness == Brightness.dark; // Indicador de modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título según tema
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del subtítulo según tema

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),  // Activa el estado hover al entrar el mouse
      onExit: (_) => setState(() => _isHovered = false),  // Desactiva el estado hover al salir el mouse
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200), // Duración de la transición suave
        padding: const EdgeInsets.all(16),            // Relleno interno
        decoration: BoxDecoration(
          color: theme.cardColor, // Color de fondo del contenedor según tema
          borderRadius: BorderRadius.circular(12), // Bordes redondeados
          border: Border.all(
            color: _isHovered
                ? widget.iconColor.withValues(alpha: isDark ? 0.50 : 0.40) // Color del borde al hacer hover
                : theme.dividerColor,                                      // Color del borde por defecto
          ),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: widget.iconColor.withValues(alpha: isDark ? 0.20 : 0.12), // Sombra resplandeciente
                    blurRadius: 14,                                              // Difuminado de la sombra
                    offset: const Offset(0, 4),                                  // Desplazamiento vertical
                  ),
                ]
              : [], // Sin sombra por defecto
        ),
        child: Row(
          children: [
            // Icono con contenedor circular traslúcido
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: widget.iconColor.withValues(alpha: _isHovered ? 0.22 : 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 24),
            ),
            const SizedBox(width: 14), // Separador horizontal

            // Textos descriptivos de la tarjeta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyle(color: subtitleColor, fontSize: 11)), // Título secundario
                  const SizedBox(height: 2),
                  Text(widget.value, style: TextStyle(color: titleColor, fontWeight: FontWeight.w900, fontSize: 15)), // Valor destacado
                  const SizedBox(height: 2),
                  Text(widget.subtitle, style: TextStyle(color: subtitleColor, fontSize: 11)), // Subtítulo secundario
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
