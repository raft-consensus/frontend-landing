// ==========================================
// Qué hace: Campo de entrada para el buscador en tiempo real de API Keys con altura homologada de 44px.
// Dónde se conecta: Consumido por AiToolbar.
// De dónde trae datos: Recibe la función callback onSearchChanged al escribir.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core Theme

/// Campo atómico de búsqueda para filtrar API Keys por nombre o prefijo
class AiToolbarSearchField extends StatelessWidget {
  const AiToolbarSearchField({
    required this.onSearchChanged, // Callback al cambiar el texto de búsqueda
    super.key,
  });

  final ValueChanged<String> onSearchChanged; // Evento de búsqueda

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema global
    final isDark = theme.brightness == Brightness.dark; // Verifica tema oscuro

    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final hintColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return SizedBox(
      height: 44, // Altura uniforme
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: 13, color: textColor),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre o API key...',
          hintStyle: TextStyle(fontSize: 13, color: hintColor),
          prefixIcon: Icon(Icons.search_rounded, size: 18, color: hintColor),
          filled: true,
          fillColor: theme.cardColor,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
