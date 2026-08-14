// ==========================================
// Qué hace: Renderiza la botonera de acciones (Rotar y Revocar) para una API Key.
// Dónde se conecta: Consumido por AiKeyRowItem tanto en diseño de escritorio como en móvil.
// De dónde trae datos: Recibe el parámetro isActive de la entidad AiKey y los callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core Theme
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain Entity

/// Botonera reutilizable con acciones de Rotación y Revocación para una API Key
class AiKeyActionButtons extends StatelessWidget {
  const AiKeyActionButtons({
    required this.item,       // Entidad AiKey para evaluar su estado
    required this.onRotate,   // Callback para ejecutar rotación
    required this.onDelete,   // Callback para ejecutar revocación
    super.key,
  });

  final AiKey item;                     // Entidad de la clave
  final ValueChanged<AiKey> onRotate;   // Evento al pulsar rotar
  final ValueChanged<AiKey> onDelete;   // Evento al pulsar revocar

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema actual
    final isActive = item.isActive; // Verifica si la clave se encuentra activa

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón de Rotar Clave
        IconButton(
          icon: const Icon(Icons.refresh_rounded, size: 18),
          tooltip: isActive ? 'Rotar Clave' : 'Clave revocada',
          color: isActive ? AppColors.info : theme.disabledColor,
          onPressed: isActive ? () => onRotate(item) : null,
        ),

        // Botón de Revocar Clave
        IconButton(
          icon: const Icon(Icons.block_rounded, size: 18),
          tooltip: isActive ? 'Revocar Clave' : 'Clave ya revocada',
          color: isActive ? AppColors.error : theme.disabledColor,
          onPressed: isActive ? () => onDelete(item) : null,
        ),
      ],
    );
  }
}
