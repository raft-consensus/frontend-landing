// ==========================================
// Qué hace: Campo de entrada para el buscador de instancias con altura homologada de 44px (idéntico a IA).
// Dónde se conecta: Consumido por DatabaseToolbar.
// De dónde trae datos: Recibe la función callback onSearchChanged al escribir.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Buscador de bases de datos con altura uniforme de 44px
class DatabaseSearchField extends StatelessWidget {
  const DatabaseSearchField({
    required this.onSearchChanged, // Callback al cambiar el texto de búsqueda
    super.key,
  });

  final ValueChanged<String> onSearchChanged; // Evento de búsqueda

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final hintColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return SizedBox(
      height: 44, // Altura uniforme estricta
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: 13, color: textColor),
        decoration: InputDecoration(
          hintText: 'Buscar por nombre, host o base de datos...',
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
