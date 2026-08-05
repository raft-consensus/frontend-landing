import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/guide_data.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/guide_card.dart';

/// ¿Qué hace?: Sub-widget de sección que administra las guías de conexión y fragmentos de código por lenguaje.
/// ¿De dónde trae datos?: Guías registradas (GuideData) y filtros por lenguaje.
/// ¿Dónde se conecta?: Renderizado dentro de ToolsAndDocsPage.
class GuidesSection extends StatefulWidget {
  const GuidesSection({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<GuidesSection> createState() => _GuidesSectionState();
}

class _GuidesSectionState extends State<GuidesSection> {
  String _selectedLanguage = 'Todas';

  final List<GuideData> _guides = const [
    GuideData(
      title: 'Conexión desde Flutter con Postgres',
      language: 'Flutter',
      description: 'Aprende a integrar tu base de datos PostgreSQL en aplicaciones Flutter usando el paquete postgres.',
      time: '3 min',
      icon: Icons.flutter_dash_rounded,
      codeSnippet: "import 'package:postgres/postgres.dart';\n\nfinal conn = await Connection.open(\n  Endpoint(host: 'pg01.raftdb.dev', database: 'mi_db', username: 'user'),\n  settings: ConnectionSettings(sslMode: SslMode.disable),\n);",
    ),
    GuideData(
      title: 'Conexión desde Node.js (Prisma ORM)',
      language: 'Node.js',
      description: 'Guía rápida para conectar Node.js / Express a tu instancia de Raft DB usando Prisma ORM.',
      time: '4 min',
      icon: Icons.code_rounded,
      codeSnippet: 'datasource db {\n  provider = "postgresql"\n  url      = env("DATABASE_URL")\n}',
    ),
    GuideData(
      title: 'Conexión con Python (psycopg2 / SQLAlchemy)',
      language: 'Python',
      description: 'Configura tus scripts de Python para interactuar con tus datos relacionales fácilmente.',
      time: '2 min',
      icon: Icons.terminal_rounded,
      codeSnippet: "import psycopg2\n\nconn = psycopg2.connect(\n    dbname='mi_db', user='user', password='pass', host='pg01.raftdb.dev', port=5432\n)",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _guides.where((guide) {
      return _selectedLanguage == 'Todas' || guide.language == _selectedLanguage;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado de sección
        const SectionHeader(
          title: 'Guías de Conexión y Documentación',
          subtitle: 'Aprende a integrar tus bases de datos con tus lenguajes y frameworks favoritos',
        ),
        const SizedBox(height: 20),

        // Chips de filtro por lenguaje
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['Todas', 'Flutter', 'Node.js', 'Python'].map((lang) {
              final isSelected = _selectedLanguage == lang;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(lang),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedLanguage = lang);
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

        // Cuadrícula responsiva de 2 columnas para escritorios/tablets
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final cols = width >= 800 ? 2 : 1; // 2 columnas si el ancho >= 800px
            final cardWidth = (width - (cols - 1) * 16) / cols;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: filtered.map((guide) {
                return SizedBox(
                  width: cardWidth,
                  child: GuideCard(
                    guide: guide,
                    onMessage: widget.onMessage,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
