import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/widgets/common/section_container.dart';
import 'package:frontend_landing/src/features/landing/widgets/common/section_title.dart';
import 'package:frontend_landing/src/features/landing/widgets/databases/database_card.dart';

/// Sección que presenta los motores de bases de datos disponibles en una grilla responsiva.
class DatabaseSection extends StatelessWidget {
  const DatabaseSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          // Título estandarizado reutilizable de common
          const SectionTitle(
            eyebrow: 'MOTORES DISPONIBLES',
            title: 'Trabaja con tus bases de datos favoritas',
            subtitle:
                'Crea una instancia y recibe los datos de conexión para comenzar.',
          ),
          const SizedBox(height: 42),

          // LayoutBuilder que calcula cuántas columnas caben según el espacio horizontal disponible
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;

              // Si ancho > 950px caben 4 tarjetas por fila
              // Si ancho > 580px caben 2 tarjetas por fila
              // En pantallas menores ocupa todo el ancho (1 tarjeta por fila)
              final cardWidth = width > 950
                  ? (width - 54) / 4
                  : width > 580
                      ? (width - 18) / 2
                      : width;

              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: [
                  DatabaseCard(
                    width: cardWidth,
                    name: 'MySQL',
                    type: 'Base de datos SQL',
                    color: const Color(0xFF0878D1),
                    icon: Icons.dns_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'PostgreSQL',
                    type: 'Base de datos SQL',
                    color: const Color(0xFF326FA4),
                    icon: Icons.storage_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'SQL Server',
                    type: 'Base de datos SQL',
                    color: const Color(0xFFE44545),
                    icon: Icons.table_chart_rounded,
                  ),
                  DatabaseCard(
                    width: cardWidth,
                    name: 'MongoDB',
                    type: 'Base de datos NoSQL',
                    color: const Color(0xFF19A85B),
                    icon: Icons.eco_rounded,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
