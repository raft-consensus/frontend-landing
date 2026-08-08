import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Modelo ligero para representar un evento de actividad reciente
class ActivityItemData {
  const ActivityItemData({
    required this.title,
    required this.desc,
    required this.time,
    required this.icon,
    required this.color,
  });

  final String title;
  final String desc;
  final String time;
  final IconData icon;
  final Color color;
}

/// ¿Qué hace?: Muestra el historial scrollable de actividad reciente (hasta 10 registros) con iluminación suave al pasar el mouse por encima.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) para colores dinámicos y fija la altura en 285px.
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica en el panel derecho de la sección central en OverviewPage.
class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

  // Lista simulada de los últimos 10 eventos de actividad reciente
  static const List<ActivityItemData> _mockActivities = [
    ActivityItemData(
      title: 'BD Creada',
      desc: 'Creaste la instancia "proyecto-universidad"',
      time: 'Hace 10 min',
      icon: Icons.add_circle_outline_rounded,
      color: Color(0xFF2A9D8F),
    ),
    ActivityItemData(
      title: 'Credenciales Consultadas',
      desc: 'Consultaste credenciales de "api-tienda-demo"',
      time: 'Hace 1 hora',
      icon: Icons.key_outlined,
      color: Color(0xFF2C7BC9),
    ),
    ActivityItemData(
      title: 'Instancia Detenida',
      desc: 'Detuviste la instancia "practica-consultas"',
      time: 'Ayer',
      icon: Icons.pause_circle_outline_rounded,
      color: Color(0xFFF28C28),
    ),
    ActivityItemData(
      title: 'Zona DNS Actualizada',
      desc: 'Registro CNAME añadido a "api.raft.dev"',
      time: 'Hace 2 días',
      icon: Icons.language_rounded,
      color: Color(0xFF2C7BC9),
    ),
    ActivityItemData(
      title: 'Workflow N8N Ejecutado',
      desc: 'Automatización de respaldo ejecutada con éxito',
      time: 'Hace 3 días',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF28C28),
    ),
    ActivityItemData(
      title: 'Consulta IA Optimizada',
      desc: 'El Asistente IA recomendó índice en "users_table"',
      time: 'Hace 4 días',
      icon: Icons.psychology_rounded,
      color: Color(0xFF2F9E6D),
    ),
    ActivityItemData(
      title: 'Dominio SSL Renovado',
      desc: 'Certificado Wildcard renovado automáticamente',
      time: 'Hace 5 días',
      icon: Icons.verified_user_outlined,
      color: Color(0xFF2A9D8F),
    ),
    ActivityItemData(
      title: 'BD Reiniciada',
      desc: 'Reinicio de la instancia "db-analitica-v1"',
      time: 'Hace 6 días',
      icon: Icons.restart_alt_rounded,
      color: Color(0xFF2C7BC9),
    ),
    ActivityItemData(
      title: 'Límite de Espacio Notificado',
      desc: 'Uso del 80% alcanzado en "tienda-online"',
      time: 'Hace 1 semana',
      icon: Icons.warning_amber_rounded,
      color: Color(0xFFE95462),
    ),
    ActivityItemData(
      title: 'Inicio de Sesión',
      desc: 'Acceso exitoso desde nueva dirección IP',
      time: 'Hace 1 semana',
      icon: Icons.security_rounded,
      color: Color(0xFF2A9D8F),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 1. Detecta la luminosidad del tema activo (Día vs Noche)
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 2. Colores dinámicos del contenedor
    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      height: 285, // Altura exacta de 285px idéntica a EcosystemServicesCard
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sub-widget 1: Cabecera "Actividad Reciente"
          _ActivityHeader(titleColor: titleColor, isDark: isDark),
          const SizedBox(height: 14),

          // Sub-widget 2: Lista scrollable interna de hasta 10 registros
          Expanded(
            child: ListView.separated(
              itemCount: _mockActivities.length,
              separatorBuilder: (context, index) => Divider(
                height: 12,
                color: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.06),
              ),
              itemBuilder: (context, index) {
                final activity = _mockActivities[index];
                return _ActivityItemRow(
                  activity: activity,
                  titleColor: titleColor,
                  subtitleColor: subtitleColor,
                  isDark: isDark,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Sub-widget privado 1: Cabecera con título e icono de reloj
class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({
    required this.titleColor,
    required this.isDark,
  });

  final Color titleColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Actividad Reciente',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w900,
            fontSize: 16,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.history_rounded,
          size: 20,
          color: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
        ),
      ],
    );
  }
}

/// Sub-widget privado 2: Fila individual con resplandor hover sutil y cursor estándar
class _ActivityItemRow extends StatefulWidget {
  const _ActivityItemRow({
    required this.activity,
    required this.titleColor,
    required this.subtitleColor,
    required this.isDark,
  });

  final ActivityItemData activity;
  final Color titleColor;
  final Color subtitleColor;
  final bool isDark;

  @override
  State<_ActivityItemRow> createState() => _ActivityItemRowState();
}

class _ActivityItemRowState extends State<_ActivityItemRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoverBg = widget.isDark
        ? Colors.white.withValues(alpha: 0.03)
        : Colors.black.withValues(alpha: 0.03);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.basic, // 👈 Cursor normal (no es botón)
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icono representativo con el color del evento
            Icon(widget.activity.icon, color: widget.activity.color, size: 18),
            const SizedBox(width: 10),

            // Textos del evento
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.title,
                    style: TextStyle(
                      color: widget.titleColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    widget.activity.desc,
                    style: TextStyle(
                      color: widget.subtitleColor,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.activity.time,
                    style: TextStyle(
                      color: widget.subtitleColor.withValues(alpha: 0.7),
                      fontSize: 10,
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
