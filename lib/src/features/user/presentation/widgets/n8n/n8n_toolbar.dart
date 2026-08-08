import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Barra de herramientas con caja de texto para filtrar flujos de trabajo en tiempo real.
/// ¿De dónde trae datos?: Ingesta la cantidad total de flujos y emite cambios a través de onSearchChanged.
/// ¿Hacia dónde va / Cómo se conecta?: Se ubica arriba de la tabla de flujos en N8nServicesPage.
class N8nToolbar extends StatelessWidget {
  final int totalWorkflows;                          // Recuento de flujos a mostrar en la etiqueta
  final ValueChanged<String> onSearchChanged;         // Callback que notifica el texto tipeado por el usuario

  const N8nToolbar({
    required this.totalWorkflows,
    required this.onSearchChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);                 // Tema activo
    final isDark = theme.brightness == Brightness.dark; // Identifica modo noche

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del texto principal

    return Row(
      children: [
        // Título de la sección de flujos con badge del total
        Row(
          children: [
            Text(
              'Mis Flujos de Trabajo',
              style: TextStyle(color: titleColor, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.navy.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$totalWorkflows', // Muestra la cantidad total de flujos
                style: const TextStyle(color: AppColors.navy, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ],
        ),
        const Spacer(), // Empuja el buscador hacia la derecha

        // Caja de entrada de texto (TextField) para la búsqueda en tiempo real
        SizedBox(
          width: 240, // Ancho fijo del campo de búsqueda
          child: TextField(
            onChanged: onSearchChanged, // Notifica cada letra tipeada
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Buscar flujo...', // Texto de orientación
              prefixIcon: const Icon(Icons.search_rounded, size: 18), // Icono de lupa
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: theme.cardColor, // Color de fondo del input
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: theme.dividerColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
