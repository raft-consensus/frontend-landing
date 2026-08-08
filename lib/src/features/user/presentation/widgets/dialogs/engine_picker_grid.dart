import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/databse_engine.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/engine_icon.dart'; // Common

/// ¿Qué hace?: Cuadrícula responsiva para seleccionar el motor de BD con logos PNG oficiales y soporte Día/Noche.
/// ¿De dónde trae datos?: Recibe la lista de motores y el callback al seleccionar.
/// ¿Dónde se conecta?: Se utiliza en CreateDatabaseDialog.
class EnginePickerGrid extends StatelessWidget {
  const EnginePickerGrid({
    required this.engines,
    required this.selectedIndex,
    required this.onSelectEngine,
    this.disabled = false,
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
        final itemWidth = width >= 500 ? (width - 12) / 2 : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(
            engines.length,
            (index) {
              final engine = engines[index];
              final isSelected = selectedIndex == index;
              final isEnabled = engine.isAvailable && !disabled;

              return _EngineCardTile(
                engine: engine,
                isSelected: isSelected,
                isEnabled: isEnabled,
                itemWidth: itemWidth,
                onTap: isEnabled ? () => onSelectEngine(index) : null,
              );
            },
          ),
        );
      },
    );
  }
}

/// Sub-widget extraído: Tarjeta interactiva individual para cada motor
class _EngineCardTile extends StatelessWidget {
  const _EngineCardTile({
    required this.engine,
    required this.isSelected,
    required this.isEnabled,
    required this.itemWidth,
    required this.onTap,
  });

  final DatabaseEngine engine;
  final bool isSelected;
  final bool isEnabled;
  final double itemWidth;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Opacity(
        opacity: engine.isAvailable ? 1.0 : 0.55,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: itemWidth,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected
                ? engine.color.withValues(alpha: isDark ? 0.18 : 0.10)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? engine.color : theme.dividerColor,
              width: isSelected ? 1.8 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // Logo PNG transparente del motor
              EngineIcon(
                engineName: engine.name, //  Pasa el nombre para cargar la imagen PNG oficial
                icon: engine.icon,
                color: engine.color,
                small: true,
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          engine.name,
                          style: TextStyle(
                            color: titleColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        if (!engine.isAvailable)
                          const _ComingSoonBadge(),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Versión ${engine.version}',
                      style: TextStyle(
                        color: subtitleColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected && engine.isAvailable)
                Icon(
                  Icons.check_circle_rounded,
                  color: engine.color,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sub-widget extraído: Insignia gráfica "Próximamente"
class _ComingSoonBadge extends StatelessWidget {
  const _ComingSoonBadge();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppColors.nightBorder : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        'Próximamente',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.nightTextSecondary : const Color(0xFF64748B),
        ),
      ),
    );
  }
}
