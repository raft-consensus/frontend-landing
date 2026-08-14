// ==========================================
// Qué hace: Botón destacado "+ Generar API Key" con altura homologada de 44px y padding cómodo.
// Dónde se conecta: Consumido por AiToolbar.
// De dónde trae datos: Recibe el callback onCreateNew.
// ==========================================

import 'package:flutter/material.dart';

/// Botón de acción principal para iniciar la generación de una nueva API Key
class AiToolbarCreateButton extends StatelessWidget {
  const AiToolbarCreateButton({
    required this.onCreateNew, // Callback para abrir el diálogo de creación
    this.isFullWidth = false, // Define si debe abarcar todo el ancho en móviles
    super.key,
  });

  final VoidCallback onCreateNew; // Evento al hacer clic
  final bool isFullWidth; // Modo expandido para layouts móviles

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = FilledButton.icon(
      onPressed: onCreateNew,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text(
        'Generar API Key',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(0, 44), // Altura idéntica al buscador
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: 44, child: button);
    }
    return button;
  }
}
