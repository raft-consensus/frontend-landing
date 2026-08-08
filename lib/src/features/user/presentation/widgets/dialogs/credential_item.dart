import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Componente de fila individual para visualizar un dato de credencial (Host, Puerto, etc.) con soporte Día/Noche.
/// ¿De dónde trae datos?: Ingesta la etiqueta, el valor y responde al tema de MaterialApp.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de CredentialsDialog.
class CredentialItem extends StatelessWidget {
  const CredentialItem({
    required this.label,   // Etiqueta del campo (ej. "Host", "Usuario")
    required this.value,   // Valor de la credencial (ej. "49.13.85.216")
    this.onCopy,           // Acción para copiar al portapapeles
    this.trailing,         // Widget opcional a la derecha (ej. grupo de botones para password)
    super.key,
  });

  final String label;
  final String value;
  final VoidCallback? onCopy;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 50,
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: SelectableText(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontFamily: 'monospace',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing ??
                    IconButton(
                      tooltip: 'Copiar',
                      onPressed: onCopy,
                      icon: Icon(
                        Icons.copy_rounded,
                        size: 18,
                        color: labelColor,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
