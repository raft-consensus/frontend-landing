import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/hub_status_badge.dart';

/// ¿Qué hace?: Tarjeta de servicio con botones independientes para creación directa y navegación.
/// ¿De dónde trae datos?: Ingesta icono, título, subtítulo, etiquetas de botón y callbacks onAction u onNavigate.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza de forma modular dentro de ServicesHubDialog.
class HubServiceTile extends StatelessWidget {
  final String title;               // Título del servicio (ej: "Bases de Datos Distribuidas")
  final String subtitle;            // Descripción breve
  final IconData icon;              // Icono distintivo del servicio
  final Color color;                // Color temático
  final String status;              // Estado ("Activo")
  final String actionLabel;         // Etiqueta del botón de creación rápida (ej: "+ Nueva BD")
  final IconData actionIcon;        // Icono del botón de creación rápida
  final VoidCallback onAction;      // Callback que abre el modal de creación directo
  final VoidCallback onNavigate;    // Callback que redirige al panel en el sidebar

  const HubServiceTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
    required this.actionLabel,
    required this.actionIcon,
    required this.onAction,
    required this.onNavigate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del subtítulo
    final tileBg = color.withValues(alpha: isDark ? 0.12 : 0.06); // Color de fondo tenue adaptativo

    return Container(
      padding: const EdgeInsets.all(14), // Relleno interno
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(12), // Bordes redondeados
        border: Border.all(color: color.withValues(alpha: isDark ? 0.40 : 0.25)), // Borde de color sutil
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fila Superior: Icono + Título + Subtítulo + Badge
          Row(
            children: [
              // Icono representativo del servicio
              CircleAvatar(
                radius: 18,
                backgroundColor: color.withValues(alpha: 0.16),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),

              // Información del servicio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(color: titleColor, fontWeight: FontWeight.w800, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        HubStatusBadge(status: status), // Badge de estado
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(color: subtitleColor, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Fila Inferior: Botones de Acción Independientes
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 1. Botón Primario: Creación Directa (Abre el Modal específico del servicio sin ir a la pestaña)
              ElevatedButton.icon(
                onPressed: onAction, // Ejecuta la acción de creación directa
                icon: Icon(actionIcon, size: 14, color: Colors.white),
                label: Text(
                  actionLabel,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
              const SizedBox(width: 8),

              // 2. Botón Secundario: Navegación al Sidebar ("Ir al panel")
              OutlinedButton.icon(
                onPressed: onNavigate, // Redirige a la pestaña correspondiente en el sidebar
                icon: const Icon(Icons.arrow_forward_rounded, size: 14),
                label: const Text('Ir al panel', style: TextStyle(fontSize: 11)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
