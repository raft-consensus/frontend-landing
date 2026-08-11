import 'package:flutter/material.dart';

/// Encabezado modular de la tarjeta de seguridad.
/// 
/// ¿Qué hace?: Muestra el icono de escudo, el título principal y la descripción descriptiva con soporte para tema dinámico.
/// ¿De dónde recibe datos?: Lee directamente Theme.of(context).
/// ¿Hacia dónde se conecta?: Renderizado en el encabezado de SecurityCard.
class SecurityHeader extends StatelessWidget {
  const SecurityHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.shield_outlined,
              color: colorScheme.primary,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              'Seguridad y Contraseña',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Mantén tu cuenta protegida cambiando tu clave periódicamente.',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
