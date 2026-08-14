// ==========================================
// Que hace: Barra horizontal desplazable que encapsula los botones selectores de servicio.
// De donde trae datos: Recibe el activeIndex y el callback onTabSelected.
// Donde se conecta: Consumido en la cabecera de ToolsAndDocsPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/layout/documentation_service_tab_button.dart';

/// Barra selectora de servicios de documentacion con contenedor tematico
class DocumentationServiceSelector extends StatelessWidget {
  const DocumentationServiceSelector({
    required this.selectedIndex, // Indice de la pestana activa
    required this.onSelect, // Callback de cambio de pestana
    super.key,
  });

  final int selectedIndex; // Indice activo
  final ValueChanged<int> onSelect; // Notificador de cambio

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightSurface : const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.nightBorder : Colors.transparent,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DocumentationServiceTabButton(
              label: 'Bases de datos',
              icon: Icons.storage_rounded,
              isSelected: selectedIndex == 0,
              onTap: () => onSelect(0),
            ),
            const SizedBox(width: 4),
            DocumentationServiceTabButton(
              label: 'DNS & SSL',
              icon: Icons.language_rounded,
              isSelected: selectedIndex == 1,
              onTap: () => onSelect(1),
            ),
            const SizedBox(width: 4),
            DocumentationServiceTabButton(
              label: 'Servicio de IA',
              icon: Icons.auto_awesome_rounded,
              isSelected: selectedIndex == 2,
              onTap: () => onSelect(2),
            ),
            const SizedBox(width: 4),
            DocumentationServiceTabButton(
              label: 'Workflows (n8n)',
              icon: Icons.hub_rounded,
              isSelected: selectedIndex == 3,
              onTap: () => onSelect(3),
            ),
            const SizedBox(width: 4),
            DocumentationServiceTabButton(
              label: 'Herramientas y ayuda',
              icon: Icons.build_circle_outlined,
              isSelected: selectedIndex == 4,
              onTap: () => onSelect(4),
            ),
          ],
        ),
      ),
    );
  }
}
