import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Barra de herramientas colocada debajo del topbar con buscador y botón de "+ Nuevo Subdominio".
/// ¿De dónde trae?: Consume AppColors de core/theme y recibe callbacks de búsqueda y creación.
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
                decoration: InputDecoration(
                  hintText: 'Buscar subdominio, IP o base de datos...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: AppColors.muted,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: AppColors.border,
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
                backgroundColor: AppColors.navy,
                foregroundColor: Colors.white,
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
