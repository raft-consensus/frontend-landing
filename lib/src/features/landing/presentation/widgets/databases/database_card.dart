import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/databases/service_tech_badge.dart';
import 'package:go_router/go_router.dart';

/// ¿Qué hace?: Tarjeta interactiva detallada para cada uno de los 4 servicios principales del ecosistema Raft Cloud.
/// ¿De dónde trae datos?: Recibe width, name, type, description, color, icon y la lista de techBadges.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en la grilla responsiva de DatabaseSection.
class DatabaseCard extends StatelessWidget {
  const DatabaseCard({
    required this.width, // Ancho responsivo asignado por el LayoutBuilder
    required this.name, // Nombre principal del servicio
    required this.type, // Subtítulo o categoría corta
    required this.description, // Explicación detallada de características
    required this.color, // Color característico del servicio
    required this.icon, // Icono principal
    required this.techBadges, // Lista de insignias de tecnologías incluidas
    super.key,
  });

  final double width;
  final String name;
  final String type;
  final String description;
  final Color color;
  final IconData icon;
  final List<ServiceTechBadge> techBadges;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark; // Tema activo

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface; // Fondo adaptable
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder; // Borde adaptable
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Texto título
    final textColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary; // Texto cuerpo

    return HoverCard(
      borderRadius: 18,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(22), // Padding interior uniforme
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera con Icono de servicio y Badge de estado Disponible
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 3, backgroundColor: AppColors.success),
                      SizedBox(width: 4),
                      Text(
                        'Disponible',
                        style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nombre y categoría del servicio
            Text(name, style: TextStyle(color: titleColor, fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(type, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),

            // Descripción extendida del servicio
            Text(description, style: TextStyle(color: textColor, fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),

            // Insignias de tecnologías / motores incluidos
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: techBadges,
            ),
            const SizedBox(height: 20),

            // Botón de acción para crear/activar servicio
            InkWell(
              onTap: () => context.push('/register'),
              borderRadius: BorderRadius.circular(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Comenzar con $name', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
