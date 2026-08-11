import 'package:flutter/material.dart';

/// Encabezado modular de la tarjeta de perfil personal.
/// 
/// ¿Qué hace?: Muestra el icono de perfil, el título principal y el badge del Rol ajustado al tema.
/// ¿De dónde recibe datos?: Del rol del usuario ([role]) y Theme.of(context).
/// ¿Hacia dónde se conecta?: Renderizado en el encabezado de ProfileInfoCard.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.role,
    super.key,
  });

  final String role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline_rounded, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              'Información Personal',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Rol: $role',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Información asociada a tu cuenta institucional.',
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
