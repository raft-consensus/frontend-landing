// ==========================================
// Qué hace: Botón destacado "+ Generar API Key" con soporte para deshabilitarse al alcanzar el límite.
// Dónde se conecta: Consumido por AiToolbar.
// De dónde trae datos: Recibe el flag isLimitReached y el callback onCreateNew.
// ==========================================

import 'package:flutter/material.dart';

/// Botón atómico de acción principal para iniciar la generación de una nueva API Key
class AiToolbarCreateButton extends StatelessWidget {
  const AiToolbarCreateButton({
    required this.isLimitReached,  // Indica si el usuario alcanzó la cuota máxima
    required this.onCreateNew,      // Callback para abrir el diálogo de creación
    this.isFullWidth = false,       // Define si debe abarcar todo el ancho (en móviles)
    super.key,
  });

  final bool isLimitReached;   // Estado de cuota
  final VoidCallback onCreateNew; // Evento al hacer clic
  final bool isFullWidth;      // Modo expandido para layouts móviles

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema global

    final button = FilledButton.icon(
      onPressed: isLimitReached ? null : onCreateNew,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text('Generar API Key'),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
