import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Trae AppColors de core
import 'package:frontend_landing/src/features/user/domain/entities/databse_engine.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Trae el widget de insignia de motor EngineIcon

/// ¿Qué hace?: Cuadrícula responsiva interactiva para seleccionar el motor de BD (PostgreSQL, MySQL, etc.).
/// ¿De dónde trae?: Trae AppColors (core), DatabaseEngine (domain/entities) y EngineIcon (presentation/widgets/common).
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de CreateDatabaseDialog.
class EnginePickerGrid extends StatelessWidget {
  const EnginePickerGrid({
    required this.engines,         // Lista de motores (domain/entities/database_engine.dart)
    required this.selectedIndex,   // Índice del motor actualmente seleccionado en pantalla
    required this.onSelectEngine,  // Evento al presionar un motor
    this.disabled = false,         // Deshabilita clics si se está procesando
    super.key,
  });

  final List<DatabaseEngine> engines;
  final int selectedIndex;
  final ValueChanged<int> onSelectEngine;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Responsividad: 2 columnas en pantallas anchas (>= 500px) o 1 columna en pantallas reducidas
        final itemWidth = width >= 500 ? (width - 12) / 2 : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            engines.length,
            (index) {
              final engine = engines[index];
              final isSelected = selectedIndex == index;

              // Tarjeta interactiva clickeable para cada motor
              return InkWell(
                onTap: disabled ? null : () => onSelectEngine(index), // Cambia el motor seleccionado
                borderRadius: BorderRadius.circular(15),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: itemWidth,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? engine.color.withOpacity(0.08) // Fondo tenazmente coloreado si está activo
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isSelected ? engine.color : AppColors.border, // Borde resaltado si está seleccionado
                      width: isSelected ? 1.7 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Widget de insignia común importado desde presentation/widgets/common/engine_icon.dart
                      EngineIcon(
                        icon: engine.icon,
                        color: engine.color,
                        small: true,
                      ),
                      const SizedBox(width: 11),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              engine.name,
                              style: const TextStyle(
                                color: AppColors.text,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Versión ${engine.version}',
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icono gráfico de Check de verificación si es el seleccionado
                      if (isSelected)
                        Icon(
                          Icons.check_circle_rounded,
                          color: engine.color,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
