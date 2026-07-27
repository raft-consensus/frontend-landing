import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/tool_data.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/tools/tool_card.dart'; // Tools

/// ¿Qué hace?: Página web del catálogo de herramientas de administración con filtro por categoría y cuadrícula de tarjetas.
/// ¿De dónde trae?: Trae AppColors (core), ToolData (domain), widgets de common y ToolCard (tools).
/// ¿Hacia dónde va / Cómo se conecta?: Es la tercera pestaña renderizada dentro de DashboardPage.
class ToolsPage extends StatefulWidget {
  const ToolsPage({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<ToolsPage> createState() => _ToolsPageState();
}

class _ToolsPageState extends State<ToolsPage> {
  String _selectedCategory = 'Todas';

  final List<ToolData> _tools = const [
    ToolData(
      title: 'pgAdmin Web',
      category: 'Relacional',
      description: 'Cliente oficial web para administrar tus bases de datos PostgreSQL.',
      icon: Icons.storage_rounded,
    ),
    ToolData(
      title: 'phpMyAdmin',
      category: 'Relacional',
      description: 'Interfaz gráfica popular para la gestión de tablas y datos en MySQL.',
      icon: Icons.dns_rounded,
    ),
    ToolData(
      title: 'Mongo Express',
      category: 'NoSQL',
      description: 'Panel web interactivo para explorar documentos y colecciones MongoDB.',
      icon: Icons.eco_rounded,
    ),
    ToolData(
      title: 'Prisma Studio',
      category: 'ORM / GUI',
      description: 'Explorador visual de datos moderno para modelos de bases de datos.',
      icon: Icons.auto_awesome_rounded,
    ),
    ToolData(
      title: 'DBeaver Config',
      category: 'Cliente Desktop',
      description: 'Generador de archivos de configuración rápida para DBeaver Universal.',
      icon: Icons.desktop_windows_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filtra las herramientas por categoría seleccionada
    final filtered = _tools.where((tool) {
      return _selectedCategory == 'Todas' || tool.category.contains(_selectedCategory);
    }).toList();

    return DashboardScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Encabezado de sección
          const SectionHeader(
            title: 'Herramientas de Administración',
            subtitle: 'Conéctate a tus bases de datos mediante gestores web y clientes externos',
          ),
          const SizedBox(height: 20),

          // Chips de filtro por categoría
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Todas', 'Relacional', 'NoSQL', 'GUI'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedCategory = cat);
                    },
                    selectedColor: AppColors.navy,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.text,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Cuadrícula responsiva de herramientas
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final cols = width >= 900 ? 3 : (width >= 600 ? 2 : 1);
              final cardWidth = (width - (cols - 1) * 16) / cols;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: filtered.map((tool) {
                  return SizedBox(
                    width: cardWidth,
                    height: 220,
                    child: ToolCard(
                      tool: tool,
                      onOpen: () => widget.onMessage('Abriendo ${tool.title}...', success: true),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
