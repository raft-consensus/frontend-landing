import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/guide_data.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_scroll_view.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/common/section_header.dart' show SectionHeader;
import 'package:frontend_landing/src/features/user/presentation/widgets/documentation/guide_card.dart'; // Documentation

/// ¿Qué hace?: Página web de documentación con guías interactivas y ejemplos de código por lenguaje.
/// ¿De dónde trae?: Trae AppColors (core), GuideData (domain), widgets de common y GuideCard (documentation).
/// ¿Hacia dónde va / Cómo se conecta?: Es la cuarta pestaña renderizada dentro de DashboardPage.
class DocumentationPage extends StatefulWidget {
  const DocumentationPage({
    required this.onMessage, // Callback para notificaciones snackbar
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  State<DocumentationPage> createState() => _DocumentationPageState();
}

class _DocumentationPageState extends State<DocumentationPage> {
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

    return DashboardScrollView(
      child: Column(
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

          // Lista vertical de guías interactiva
          Column(
            children: filtered
                .map((guide) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GuideCard(
                        guide: guide,
                        onMessage: widget.onMessage,
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
