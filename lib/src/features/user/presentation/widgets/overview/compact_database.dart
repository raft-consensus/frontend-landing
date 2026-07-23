import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/status_badge.dart'; // Common

/// ¿Qué hace?: Fila compacta de base de datos para listar las instancias activas en el resumen.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), EngineIcon, engineStyle y StatusBadge (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se usa dentro de OverviewPage para listar las BD rápidas.
class CompactDatabaseCard extends StatelessWidget {
  const CompactDatabaseCard({
    required this.instance,  // Instancia de base de datos a renderizar
    required this.onTap,     // Acción al presionar la tarjeta
    super.key,
  });

  final DatabaseInstance instance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = engineStyle(instance.engine);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Insignia gráfica del motor
            EngineIcon(icon: style.icon, color: style.color, small: true),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    instance.name,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${instance.engine} v${instance.version} • ${instance.host}',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            // Badge de estado Activa/Detenida
            StatusBadge(running: instance.isRunning),
          ],
        ),
      ),
    );
  }
}
