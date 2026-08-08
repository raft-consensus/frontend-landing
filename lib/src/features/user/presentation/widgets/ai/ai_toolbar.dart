import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Barra de herramientas con buscador en tiempo real, contador de cuota y botón "+ Generar API Key".
/// ¿De dónde trae datos?: Ingesta la cuota de claves (keyCount), el callback de búsqueda y el callback onCreateNew.
/// ¿Hacia dónde va / Cómo se conecta?: Se incluye sobre la tabla principal en AiServicesPage.
class AiToolbar extends StatelessWidget {
  const AiToolbar({
    required this.keyCount,
    required this.onSearchChanged,
    required this.onCreateNew,
    this.maxKeys = 10,
    super.key,
  });

  final int keyCount; // Cantidad actual de claves
  final int maxKeys; // Límite máximo (10 por defecto)
  final ValueChanged<String> onSearchChanged; // Callback al escribir en el buscador
  final VoidCallback onCreateNew; // Acción al presionar el botón de generación

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final hintColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;
    final isLimitReached = keyCount >= maxKeys;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 650;
        return Flex(
          direction: isSmall ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: isSmall ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
          children: [
            // 1. Campo del Buscador en Tiempo Real
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: isSmall ? double.infinity : 320),
              child: TextField(
                onChanged: onSearchChanged,
                style: TextStyle(fontSize: 13, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o API key...',
                  hintStyle: TextStyle(fontSize: 13, color: hintColor),
                  prefixIcon: Icon(Icons.search_rounded, size: 18, color: hintColor),
                  filled: true,
                  fillColor: theme.cardColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
            ),
            if (isSmall) const SizedBox(height: 12),

            // 2. Contador de Cuota + Botón Principal
            Row(
              mainAxisAlignment: isSmall ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
              children: [
                // Badge Contador de API Keys
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.key_rounded,
                        size: 16,
                        color: isLimitReached ? AppColors.warning : AppColors.success,
                      ),
                      const SizedBox(width: 8),
                      Text('API Keys: ', style: TextStyle(fontSize: 12, color: hintColor)),
                      Text(
                        '$keyCount / $maxKeys',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Botón Principal "+ Generar API Key"
                FilledButton.icon(
                  onPressed: isLimitReached ? null : onCreateNew,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Generar API Key'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
