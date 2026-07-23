import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/tool_data.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart'; // Common

/// ¿Qué hace?: Tarjeta gráfica para presentar una herramienta de administración (pgAdmin, phpMyAdmin, Prisma Studio, etc.).
/// ¿De dónde trae?: Trae AppColors (core), ToolData (domain) y DashboardCard (common).
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza dentro de la cuadrícula de ToolsPage.
class ToolCard extends StatelessWidget {
  const ToolCard({
    required this.tool,      // Entidad de datos de la herramienta (título, descripción, icono, categoría)
    required this.onOpen,    // Callback al presionar el botón "Abrir herramienta"
    super.key,
  });

  final ToolData tool;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icono con caja de color pastel
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(tool.icon, color: AppColors.blue, size: 24),
              ),
              const Spacer(),
              // Badge de categoría (ej. "Relacional", "NoSQL", "GUI")
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F7FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD4E8FC)),
                ),
                child: Text(
                  tool.category,
                  style: const TextStyle(
                    color: AppColors.blue,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Título de la herramienta
          Text(
            tool.title,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),

          // Descripción de la herramienta
          Text(
            tool.description,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const Spacer(),
          const SizedBox(height: 16),

          // Botón gráfico para abrir la herramienta web o cliente
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onOpen,
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: const Text('Abrir herramienta'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.navy,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
