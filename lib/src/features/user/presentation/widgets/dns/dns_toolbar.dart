import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Barra de herramientas colocada debajo del topbar con buscador y botón de "+ Nuevo Subdominio".
/// ¿De dónde trae datos?: Consume AppColors y responde al cambio de tema Día / Noche.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye dentro del cuerpo principal de DnsSslPage.
class DnsToolbar extends StatelessWidget {
  const DnsToolbar({
    required this.onSearchChanged,
    required this.onCreateNew,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final VoidCallback onCreateNew;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final hintColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        return Flex(
          direction: isSmall ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              isSmall ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
          children: [
            // Campo del Buscador
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isSmall ? double.infinity : 360,
              ),
              child: TextField(
                onChanged: onSearchChanged,
                style: TextStyle(
                  fontSize: 13,
                  color: textColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Buscar subdominio, IP o base de datos...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: hintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: hintColor,
                  ),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.dividerColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            if (isSmall) const SizedBox(height: 12),
            // Botón Principal "+ Nuevo Subdominio"
            FilledButton.icon(
              onPressed: onCreateNew,
              icon: const Icon(
                Icons.add_rounded,
                size: 18,
              ),
              label: const Text('Nuevo Subdominio'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
