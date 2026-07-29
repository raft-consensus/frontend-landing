import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Widget de fila que representa una instancia de Base de Datos dentro del mockup.
/// 
/// ¿Qué hace?: Muestra el icono del motor, el nombre de la BD, el tipo de motor y una viñeta de estado 'Activa'.
/// ¿De dónde recibe datos?: String name, String engine y Color desde DashboardMockup.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado dentro de la lista de bases de datos en DashboardMockup.
class DashboardDbRow extends StatelessWidget {
  const DashboardDbRow({
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
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE4ECF4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(Icons.storage_rounded, color: color, size: 18),
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
                    color: AppColors.navy,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  engine,
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Text(
            '● Activa',
            style: TextStyle(
              color: Color(0xFF15965E),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
