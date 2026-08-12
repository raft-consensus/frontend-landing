import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Tarjeta informativa al pie que explica cómo funciona la integración externa y solicita ampliación de límites.
/// ¿De dónde trae datos?: Contenido informativo estático adaptado al tema activo.
/// ¿Hacia dónde va / Cómo se conecta?: Se posiciona al final de N8nServicesPage.
class N8nInfoCard extends StatelessWidget {
  const N8nInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del texto principal
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Color del texto secundario

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.navy.withValues(alpha: isDark ? 0.20 : 0.06), // Fondo azul tenso adaptativo
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy.withValues(alpha: 0.20)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.navy, size: 22), // Icono de información
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Servicio Provisto por la Célula de Automatización',
                  style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  'Las cuotas de flujos y ejecuciones son administradas externamente. Si requieres aumentar tu límite de ejecuciones mensuales, ponte en contacto con soporte.',
                  style: TextStyle(color: subtitleColor, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
