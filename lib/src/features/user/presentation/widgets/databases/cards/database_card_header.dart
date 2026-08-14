// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/databases/database_card_header.dart
// Qué hace: Muestra la cabecera de la tarjeta de base de datos con logo del motor, nombre, versión e indicador de estado.
// Dónde se conecta: Importado por DatabaseManagementCard.
// De dónde recibe datos: Recibe la entidad DatabaseInstance, EngineStyle y el color del motor.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_style.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/status_badge.dart'; // Common

/// Cabecera modular de tarjeta de BD con logo transparente, nombre, versión y badge de estado
class DatabaseCardHeader extends StatelessWidget {
  const DatabaseCardHeader({
    required this.instance,        // Instancia de la base de datos
    required this.engineStyleData, // Estilos visuales e icono del motor
    required this.engineColor,     // Color institucional del motor
    super.key,
  });

  final DatabaseInstance instance;
  final EngineStyle engineStyleData;
  final Color engineColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icono PNG transparente o gráfico del motor de BD
        EngineIcon(
          engineName: instance.engine,
          icon: engineStyleData.icon,
          color: engineColor,
          small: false,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      instance.name,
                      style: TextStyle(
                        color: titleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Badge indicador de estado activo/detenido
                  StatusBadge(running: instance.isRunning),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${instance.engine} v${instance.version} • ID: ${instance.id}',
                style: TextStyle(color: subtitleColor, fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
