import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Widget atómico que renderiza los botones de acción del banner ("Activar", "Abrir Studio", "Copiar Enlace").
/// ¿De dónde trae datos?: Ingesta estado de activación, estado de carga y callbacks de interacciones.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en el área inferior de N8nAccessBanner.
class N8nBannerActions extends StatelessWidget {
  final bool isActivated;          // Booleano: indica si la cuenta está activada
  final bool isProvisioning;       // Booleano: muestra spinner de carga durante el aprovisionamiento
  final VoidCallback onProvision;  // Callback al presionar "Activar cuenta n8n"
  final VoidCallback onLaunch;     // Callback al presionar "Abrir n8n Studio"
  final VoidCallback onCopyLink;   // Callback al presionar "Copiar Enlace de Registro"

  const N8nBannerActions({
    required this.isActivated,
    required this.isProvisioning,
    required this.onProvision,
    required this.onLaunch,
    required this.onCopyLink,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final buttonPrimaryBg = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final buttonPrimaryFg = isDark ? AppColors.nightBackground : Colors.white;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        if (!isActivated) ...[
          // Botón primario de Activación (Estado Inactivo)
          ElevatedButton.icon(
            onPressed: isProvisioning ? null : onProvision,
            icon: isProvisioning
                ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: buttonPrimaryFg))
                : const Icon(Icons.flash_on_rounded, size: 16),
            label: Text(
              isProvisioning ? 'Activando...' : 'Activar cuenta n8n',
              style: TextStyle(color: buttonPrimaryFg, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonPrimaryBg,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ] else ...[
          // Botón primario de Apertura de n8n Studio (Estado Activo)
          ElevatedButton.icon(
            onPressed: onLaunch,
            icon: Icon(Icons.launch_rounded, size: 16, color: buttonPrimaryFg),
            label: Text(
              'Abrir n8n Studio',
              style: TextStyle(color: buttonPrimaryFg, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonPrimaryBg,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),

          // Botón secundario: Copiar Enlace de Registro
          OutlinedButton.icon(
            onPressed: onCopyLink,
            icon: const Icon(Icons.key_rounded, size: 16),
            label: const Text('Copiar Enlace de Registro'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ],
    );
  }
}
