import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/guides_section.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/tools/tools_section.dart';

/// ¿Qué hace?: Página unificada que contiene el selector superior de pestañas (Herramientas Web / Guías de Conexión).
/// ¿De dónde trae datos?: Renderiza ToolsSection y GuidesSection manteniendo sus filtros individuales.
/// ¿Dónde se conecta?: Es la tercera pestaña del menú dentro de DashboardPage.
class ToolsAndDocsPage extends StatefulWidget {
  const ToolsAndDocsPage({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<ToolsAndDocsPage> createState() => _ToolsAndDocsPageState();
}

class _ToolsAndDocsPageState extends State<ToolsAndDocsPage> {
  int _activeTab = 0; // 0: Herramientas Web, 1: Guías de Conexión

  @override
  Widget build(BuildContext context) {
    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selector de vista superior
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4F8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TabButton(
                  label: 'Herramientas Web',
                  icon: Icons.build_circle_outlined,
                  isSelected: _activeTab == 0,
                  onTap: () => setState(() => _activeTab = 0),
                ),
                const SizedBox(width: 4),
                _TabButton(
                  label: 'Guías de Conexión',
                  icon: Icons.description_outlined,
                  isSelected: _activeTab == 1,
                  onTap: () => setState(() => _activeTab = 1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Renderizado condicional de la sección activa
          if (_activeTab == 0)
            ToolsSection(onMessage: widget.onMessage)
          else
            GuidesSection(onMessage: widget.onMessage),
        ],
      ),
    );
  }
}

/// Sub-widget extraído: Botón conmutador de pestaña superior
class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.navy : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.muted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.text,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
