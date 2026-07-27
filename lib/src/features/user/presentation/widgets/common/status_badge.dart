import 'package:flutter/material.dart';

/// ¿Qué hace?: Insignia gráfica estilo "pill" que indica si una base de datos está "● Activa" (verde) o "● Detenida" (gris).
/// ¿Cómo se conecta?: Se coloca en las tarjetas de BD para dar retroalimentación del estado en tiempo real.
class StatusBadge extends StatelessWidget {
  const StatusBadge({
    required this.running, // Estado booleano: true (Activa) / false (Detenida)
    super.key,
  });

  final bool running;

  @override
  Widget build(BuildContext context) {
    // Selección gráfica de color: Verde brillante si está corriendo, gris opaco si está detenida
    final color = running ? const Color(0xFF17B978) : const Color(0xFF687A91);

    // Caja flotante redondeada con texto centrado
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10), // Fondo translúcido suave del color de estado
        borderRadius: BorderRadius.circular(20), // Forma completamente ovalada (pill)
      ),
      // Texto con viñeta circular "●"
      child: Text(
        running ? '● Activa' : '● Detenida',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800, // Texto en negrita para alta visibilidad
        ),
      ),
    );
  }
}
