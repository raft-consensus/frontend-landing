import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core: Tokens de color

/// ¿Qué hace?: Fila que alinea un icono descriptivo, una etiqueta de texto y su valor con soporte Día/Noche.
/// ¿De dónde recibe datos?: Recibe icono, label, value y se adapta a Theme.of(context).
/// ¿Cómo se conecta?: Se utiliza en tarjetas de BD para desplegar datos de conexión (Host, Puerto, Usuario, etc.).
class InfoLine extends StatelessWidget {
  const InfoLine({
    required this.icon,  // Icono descriptivo a la izquierda (ej. Icons.dns)
    required this.label, // Nombre del dato (ej. "Host")
    required this.value, // Valor a mostrar (ej. "49.13.85.216")
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores dinámicos del sistema para alta legibilidad en fondo claro u oscuro
    final labelColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final valueColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Row(
      children: [
        Icon(icon, color: labelColor, size: 16), // Icono adaptado al tema
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: TextStyle(
            color: labelColor,
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis, // Si el texto es largo, lo recorta con "..."
            textAlign: TextAlign.right,      // Alineado a la derecha
            style: TextStyle(
              color: valueColor,             // Texto blanco azulado en Night, azul marino en Day
              fontSize: 11,
              fontWeight: FontWeight.w700,  // Negrita para destacar el valor
            ),
          ),
        ),
      ],
    );
  }
}
