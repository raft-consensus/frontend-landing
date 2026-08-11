import 'package:flutter/material.dart';

/// Botón de acción para solicitar mejora de plan.
/// 
/// ¿Qué hace?: Permite al usuario enviar una solicitud de upgrade a Plan Pro.
/// ¿De dónde recibe datos?: Callback [onPressed].
/// ¿Hacia dónde se conecta?: Ubicado al pie de PlanDetailsCard.
class PlanUpgradeButton extends StatelessWidget {
  const PlanUpgradeButton({
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.rocket_launch_rounded, size: 16),
        label: const Text('Mejorar a Plan Pro'),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
