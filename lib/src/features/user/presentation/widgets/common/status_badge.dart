import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core: Tokens de color

/// ¿Qué hace?: Insignia gráfica estilo "pill" que indica si una base de datos está "● Activa" o "● Detenida", con soporte Día/Noche.
/// ¿De dónde recibe datos?: Recibe el estado booleano running (true/false) y se adapta al tema de MaterialApp.
/// ¿Cómo se conecta?: Se coloca en las tarjetas de BD para dar retroalimentación de estado en tiempo real.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.running, // Estado booleano: true (Activa) / false (Detenida)
    super.key,
  });

  final bool running;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Selección dinámica de color usando los tokens del sistema:
    // Verde oficial (AppColors.success) para Activa, o Muted Text para Detenida segun el tema activo
    final color = running 
        ? AppColors.success 
        : (isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary);

    // Caja flotante redondeada con fondo translúcido adaptativo
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.18 : 0.10), // Translúcido suave adaptado
        borderRadius: BorderRadius.circular(20), // Forma completamente pill
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.30 : 0.20), // Borde tenue para mayor definición
          width: 1,
        ),
      ),
      // Texto con viñeta circular "●"
      child: Text(
        running ? '● Activa' : '● Detenida',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800, // Negrita para alta legibilidad
        ),
      ),
    );
  }
}
