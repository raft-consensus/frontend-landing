// ==========================================
// Qué hace: Botón de acción "+ Nueva BD" con altura mínima de 44px y padding amplio (idéntico a IA).
// Dónde se conecta: Consumido por DatabaseToolbar.
// De dónde trae datos: Recibe el callback onCreateNew.
// ==========================================

import 'package:flutter/material.dart';

/// Botón principal de aprovisionamiento de bases de datos
class DatabaseCreateButton extends StatelessWidget {
  const DatabaseCreateButton({
    required this.onCreateNew, // Callback para abrir diálogo de creación
    this.isFullWidth = false, // Define si debe abarcar todo el ancho en móviles
    super.key,
  });

  final VoidCallback onCreateNew; // Evento al hacer clic
  final bool isFullWidth; // Modo expandido para móviles

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = FilledButton.icon(
      onPressed: onCreateNew,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text(
        'Nueva BD',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        minimumSize: const Size(0, 44), // Altura idéntica al buscador
        padding: const EdgeInsets.symmetric(horizontal: 28), // Espacio lateral cómodo
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: 44, child: button);
    }
    return button;
  }
}
