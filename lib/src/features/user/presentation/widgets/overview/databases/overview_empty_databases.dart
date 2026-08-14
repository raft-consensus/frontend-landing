// ==========================================
// Qué hace: Tarjeta visual de estado vacío cuando el usuario aún no ha creado bases de datos.
// Dónde se conecta: Renderizado en OverviewDatabasesGrid.
// De dónde trae datos: Recibe el callback onCreateDatabase.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Estado vacío amigable para la sección de bases de datos en el resumen
class OverviewEmptyDatabases extends StatelessWidget {
  const OverviewEmptyDatabases({
    required this.onCreateDatabase, // Callback al presionar el botón de crear
    super.key,
  });

  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? AppColors.nightCard : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. Icono de base de datos vacía
          Icon(
            Icons.dns_outlined,
            size: 48,
            color: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
          ),
          const SizedBox(height: 14),

          // 2. Título informativo
          Text(
            'No tienes instancias creadas',
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 6),

          // 3. Subtítulo descriptivo
          Text(
            'Crea tu primera base de datos relacional o NoSQL en un clic.',
            style: TextStyle(color: subtitleColor, fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // 4. Botón de creación
          FilledButton.icon(
            onPressed: onCreateDatabase,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('+ Crear Instancia'),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2A9D8F),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
