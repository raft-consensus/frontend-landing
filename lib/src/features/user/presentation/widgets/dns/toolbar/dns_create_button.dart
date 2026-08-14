// ==========================================
// Qué hace: Botón de acción destacado "+ Nuevo Subdominio" de 44px con padding cómodo.
// Dónde se conecta: Consumido por DnsToolbar.
// De dónde trae datos: Recibe el callback onCreateNew.
// ==========================================

import 'package:flutter/material.dart';

/// Botón principal para aprovisionar subdominios
class DnsCreateButton extends StatelessWidget {
  const DnsCreateButton({
    required this.onCreateNew, // Callback para abrir diálogo de creación
    this.isFullWidth = false, // Define si debe abarcar todo el ancho en móviles
    super.key,
  });

  final VoidCallback onCreateNew; // Evento de clic
  final bool isFullWidth; // Ancho completo en móvil

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = FilledButton.icon(
      onPressed: onCreateNew,
      icon: const Icon(Icons.add_rounded, size: 18),
      label: const Text(
        'Nuevo Subdominio',
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
