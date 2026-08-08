import 'package:flutter/material.dart';

/// ¿Qué hace?: Muestra un badge visual de color verde si el flujo está activo o naranja si está pausado.
/// ¿De dónde trae datos?: Ingesta la propiedad booleana isActive de la entidad N8nWorkflow.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en N8nWorkflowRowItem dentro de la tabla de flujos.
class N8nWorkflowStatusBadge extends StatelessWidget {
  final bool isActive; // Booleano: true para Activo, false para Pausado

  const N8nWorkflowStatusBadge({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Define el color principal según el estado booleano
    final badgeColor = isActive ? Colors.green : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), // Relleno interno
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12), // Fondo traslúcido tenue
        borderRadius: BorderRadius.circular(20),     // Forma de píldora redondeada
        border: Border.all(color: badgeColor.withValues(alpha: 0.30)), // Borde suave
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Punto indicador resplandeciente
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),

          // Texto descriptivo del estado
          Text(
            isActive ? 'Activo' : 'Pausado',
            style: TextStyle(
              color: badgeColor,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
