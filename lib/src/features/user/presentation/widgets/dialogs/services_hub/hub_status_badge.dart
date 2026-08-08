import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Renderiza una insignia de estado coloreada ("Activo", "Disponible") para cada servicio del Hub.
/// ¿De dónde trae datos?: Ingesta la etiqueta status y detecta el tema activo (Raft Day / Raft Night).
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en HubServiceTile dentro del modal ServicesHubDialog.
class HubStatusBadge extends StatelessWidget {
  final String status; // Texto del estado (ej: "Activo", "Disponible")

  const HubStatusBadge({
    required this.status, // Requerido: Etiqueta de estado
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final activeColor = AppColors.success; // Color verde de éxito para servicios activos

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), // Relleno interno
      decoration: BoxDecoration(
        color: activeColor.withValues(alpha: isDark ? 0.20 : 0.12), // Fondo traslúcido tenue
        borderRadius: BorderRadius.circular(6),                      // Esquinas redondeadas
        border: Border.all(color: activeColor.withValues(alpha: 0.30)), // Borde fino
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
