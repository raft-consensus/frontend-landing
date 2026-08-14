// ==========================================
// Qué hace: Campo de entrada para búsqueda en tiempo real de registros DNS por FQDN, IP o nota.
// Dónde se conecta: Consumido por DnsToolbar.
// De dónde trae datos: Recibe el callback onSearchChanged al escribir.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Buscador de registros DNS con altura de 44px
class DnsSearchField extends StatelessWidget {
  const DnsSearchField({
    required this.onSearchChanged, // Callback al escribir
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
      height: 44, // Altura uniforme
      child: TextField(
        onChanged: onSearchChanged,
        style: TextStyle(fontSize: 13, color: textColor),
        decoration: InputDecoration(
          hintText: 'Buscar subdominio, IP o base de datos...',
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
