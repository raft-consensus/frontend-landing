import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';
import 'package:go_router/go_router.dart';

/// Tarjeta individual para mostrar un motor de base de datos (MySQL, PostgreSQL, etc.).
class DatabaseCard extends StatelessWidget {
  const DatabaseCard({
    required this.width,
    required this.name,
    required this.type,
    required this.color,
    required this.icon,
    super.key,
  });

  /// Ancho dinámico calculado por el LayoutBuilder según la pantalla.
  final double width;

  /// Nombre de la base de datos (ej. "PostgreSQL").
  final String name;

  /// Tipo de motor (ej. "Base de datos SQL" o "Base de datos NoSQL").
  final String type;

  /// Color representativo de la marca del motor.
  final Color color;

  /// Icono del motor.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      borderRadius: 22,
      onTap: () => context.push('/register'),
      child: Container(
        width: width,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE0EAF4)),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icono dentro de una caja con el color distintivo del motor
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: color, size: 27),
                ),
                const Spacer(),
                // Badge verde de disponibilidad
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9F9F0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '● Disponible',
                    style: TextStyle(
                      color: Color(0xFF12864E),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Nombre del motor (ej. MySQL)
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            // Tipo de BD
            Text(type),
            const SizedBox(height: 20),
            // Botón de acción rápido
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/register'),
                child: const Text('Crear instancia'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
