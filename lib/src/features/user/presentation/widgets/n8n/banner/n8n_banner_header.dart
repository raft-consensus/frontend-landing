import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Widget atómico que renderiza el icono distintivo, el título y la descripción del banner n8n.
/// ¿De dónde trae datos?: Ingesta el estado booleano de activación (isActivated) para alternar los mensajes explicativos.
/// ¿Hacia dónde va / Cómo se conecta?: Se consume dentro del encabezado de N8nAccessBanner.
class N8nBannerHeader extends StatelessWidget {
  final bool isActivated; // Booleano: true si la cuenta está lista, false si está pendiente de activación

  const N8nBannerHeader({
    required this.isActivated, // Requerido: Estado de la cuenta
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Objeto de tema actual
    final isDark = theme.brightness == Brightness.dark; // Booleano: indica si está en modo oscuro (Raft Night)

    final primaryTextColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título
    final secondaryTextColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color de descripción

    return Row(
      children: [
        // Contenedor circular con el icono del servicio
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.nightPrimary : AppColors.dayPrimary).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.open_in_browser_rounded,
            color: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
            size: 24,
          ),
        ),
        const SizedBox(width: 14),

        // Textos del encabezado
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entorno de Trabajo n8n Studio',
                style: TextStyle(color: primaryTextColor, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                isActivated
                    ? 'Crea, edita y automatiza tus flujos visuales utilizando la plataforma de n8n.'
                    : 'Activa tu espacio de trabajo en n8n para comenzar a construir flujos de automatización.',
                style: TextStyle(color: secondaryTextColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
