// ==========================================
// Que hace: Boton atomico individual para una opcion de la barra de servicios documental.
// De donde trae datos: Recibe label, icono, estado de seleccion y callback onTap.
// Donde se conecta: Consumido dentro de DocumentationServiceSelector.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Boton individual de pestana con animacion de seleccion y soporte para modo oscuro
class DocumentationServiceTabButton extends StatelessWidget {
  const DocumentationServiceTabButton({
    required this.label, // Texto visible de la pestana
    required this.icon, // Icono del servicio
    required this.isSelected, // Indicador de estado activo
    required this.onTap, // Callback al presionar
    super.key,
  });

  final String label; // Nombre de la pestana
  final IconData icon; // Icono representativo
  final bool isSelected; // Estado booleano de seleccion
  final VoidCallback onTap; // Accion al hacer clic

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Colores dinamicos segun iluminacion
    final activeBg = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final activeFg = isDark ? AppColors.nightBackground : Colors.white;
    final inactiveFg = theme.textTheme.bodyMedium?.color ?? AppColors.dayTextSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? activeFg : inactiveFg,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeFg : inactiveFg,
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
