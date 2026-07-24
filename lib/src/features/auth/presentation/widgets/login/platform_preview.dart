import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Tarjeta contenedor que simula la vista previa del panel de control del usuario con sus bases de datos activas.
class PlatformPreview extends StatelessWidget {
  const PlatformPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Container(
        padding: const EdgeInsets.all(19),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.055),
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: const Column(
          children: [
            PreviewHeader(),
            SizedBox(height: 15),
            PreviewInstance(
              name: 'proyecto-universidad',
              engine: 'PostgreSQL',
              color: Color(0xFF45A7E8),
            ),
            SizedBox(height: 10),
            PreviewInstance(
              name: 'api-tienda',
              engine: 'MongoDB',
              color: Color(0xFF26C978),
            ),
          ],
        ),
      ),
    );
  }
}

/// Encabezado de la simulación del panel ("Tus bases de datos" - 2 activas).
class PreviewHeader extends StatelessWidget {
  const PreviewHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Icon(
          Icons.dashboard_rounded,
          color: AppColors.cyan,
          size: 20,
        ),
        SizedBox(width: 9),
        Text(
          'Tus bases de datos',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        Spacer(),
        Text(
          '2 activas',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Fila individual que simula una instancia de base de datos activa dentro de la vista previa.
class PreviewInstance extends StatelessWidget {
  const PreviewInstance({
    required this.name,
    required this.engine,
    required this.color,
    super.key,
  });

  final String name;
  final String engine;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.065),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: color.withOpacity(0.17),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.storage_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  engine,
                  style: const TextStyle(
                    color: Color(0xFF91A6C0),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            '● Activa',
            style: TextStyle(
              color: Color(0xFF17B778),
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
