import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Encabezado superior del modal Ecosistema Raft Hub con icono, título y botón de cierre.
/// ¿De dónde trae datos?: Ingesta Theme.of(context) para adaptar colores Día/Noche.
/// ¿Hacia dónde va / Cómo se conecta?: Se posiciona en la parte superior de ServicesHubDialog.
class HubHeader extends StatelessWidget {
  const HubHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del subtítulo

    return Row(
      children: [
        // Avatar circular con icono de aplicaciones/hub
        CircleAvatar(
          radius: 20,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.apps_rounded, color: theme.colorScheme.primary, size: 22),
        ),
        const SizedBox(width: 14),

        // Título y descripción breve del Hub de Atajos
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hub de Servicios Raft',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Acceso directo a modales de creación y paneles de cada servicio',
                style: TextStyle(color: subtitleColor, fontSize: 11),
              ),
            ],
          ),
        ),

        // Botón de cierre (X)
        IconButton(
          onPressed: () => Navigator.pop(context), // Cierra el modal dialog
          icon: Icon(Icons.close_rounded, color: subtitleColor, size: 20),
          tooltip: 'Cerrar ventana',
        ),
      ],
    );
  }
}
