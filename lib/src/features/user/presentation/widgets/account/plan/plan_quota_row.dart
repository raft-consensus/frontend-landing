import 'package:flutter/material.dart';

/// Fila modular que representa un límite o cuota de uso del plan.
/// 
/// ¿Qué hace?: Renderiza el par Etiqueta - Valor con tipografía y contraste según el tema claro/oscuro.
/// ¿De dónde recibe datos?: De las propiedades [label] y [value].
/// ¿Hacia dónde se conecta?: Renderizado en la lista de límites de PlanDetailsCard.
class PlanQuotaRow extends StatelessWidget {
  const PlanQuotaRow({
    required this.label,
    required this.value,
    super.key,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
