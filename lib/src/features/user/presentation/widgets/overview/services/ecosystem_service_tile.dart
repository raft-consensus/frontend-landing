// ==========================================
// Qué hace: Fila interactiva para cada servicio del ecosistema con micro-interacción Hover y badge de estado.
// Dónde se conecta: Consumido por EcosystemServicesCard.
// De dónde trae datos: Recibe icono, color, título, descripción, estado y callback onTap.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Fila individual interactiva del catálogo de servicios Raft
class EcosystemServiceTile extends StatefulWidget {
  const EcosystemServiceTile({
    required this.icon, // Icono distintivo del servicio
    required this.color, // Color temático
    required this.title, // Nombre del servicio
    required this.description, // Breve descripción
    required this.status, // Texto del badge de estado (ej: "Activo", "Disponible")
    this.onTap, // Acción al hacer clic
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String status;
  final VoidCallback? onTap;

  @override
  State<EcosystemServiceTile> createState() => _EcosystemServiceTileState();
}

class _EcosystemServiceTileState extends State<EcosystemServiceTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hoverBg = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.02);

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                // 1. Icono con fondo translúcido
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: isDark ? 0.20 : 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 20),
                ),
                const SizedBox(width: 12),

                // 2. Título y descripción
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: titleColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.description,
                        style: TextStyle(color: subtitleColor, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // 3. Badge de estado
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.color.withValues(alpha: isDark ? 0.20 : 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
