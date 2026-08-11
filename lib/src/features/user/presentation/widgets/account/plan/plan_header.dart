import 'package:flutter/material.dart';

/// Encabezado modular con la insignia del plan del usuario.
/// 
/// ¿Qué hace?: Muestra el icono de trofeo/premium y el distintivo "Plan Gratuito Activo" adaptado al tema.
/// ¿De dónde recibe datos?: Theme.of(context).
/// ¿Hacia dónde se conecta?: Renderizado en el encabezado de PlanDetailsCard.
class PlanHeader extends StatelessWidget {
  const PlanHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.workspace_premium_rounded, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan Estudiante',
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Plan Gratuito Activo',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
