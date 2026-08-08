// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/overview/service_item_tile.dart
// ¿Qué hace?: Renderiza la tarjeta cliqueable para un servicio del ecosistema con iluminación suave de fondo y cursor tipo manito.
// ¿De dónde trae datos?: Ingesta icono, color, título, descripción, estado y callback de navegación.
// ¿Hacia dónde va / Cómo se conecta?: Es invocado dentro de EcosystemServicesCard.
// ==========================================

import 'package:flutter/material.dart';

class ServiceItemTile extends StatefulWidget {
  const ServiceItemTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.status,
    required this.titleColor,
    required this.subtitleColor,
    required this.isDark,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final String status;
  final Color titleColor;
  final Color subtitleColor;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  State<ServiceItemTile> createState() => _ServiceItemTileState();
}

class _ServiceItemTileState extends State<ServiceItemTile> {
  bool _isHovered = false; // Estado reactivo de hover

  @override
  Widget build(BuildContext context) {
    // 1. Colores dinámicos del contenedor
    final defaultBg = widget.isDark ? const Color(0xFF162536) : const Color(0xFFF5F9FD);
    final hoverBg = widget.isDark ? const Color(0xFF1B2D42) : const Color(0xFFEDF4FC);

    final defaultBorder = widget.isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.05);
    final hoverBorder = widget.color.withValues(alpha: 0.45);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click, // Puntero manito forzado en toda la tarjeta
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : defaultBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isHovered ? hoverBorder : defaultBorder,
            width: 1.0,
          ),
        ),
        child: InkWell(
          onTap: widget.onTap ?? () {}, // Garantiza respuesta a clic e intercepción de eventos
          borderRadius: BorderRadius.circular(12),
          hoverColor: Colors.transparent,
          splashColor: widget.color.withValues(alpha: 0.12),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Sub-widget 1: Icono del servicio
                _ServiceIcon(icon: widget.icon, color: widget.color),
                const SizedBox(width: 12),

                // Sub-widget 2: Título y descripción
                Expanded(
                  child: _ServiceTextDetails(
                    title: widget.title,
                    description: widget.description,
                    titleColor: widget.titleColor,
                    subtitleColor: widget.subtitleColor,
                  ),
                ),
                const SizedBox(width: 8),

                // Sub-widget 3: Badge de estado pill
                _ServiceStatusBadge(status: widget.status),
                const SizedBox(width: 8),

                // Sub-widget 4: Botón de flecha con cambio de color al hacer hover
                Icon(
                  Icons.chevron_right_rounded,
                  color: _isHovered ? widget.color : widget.subtitleColor,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sub-widget privado 1: Icono del servicio con fondo tintado
class _ServiceIcon extends StatelessWidget {
  const _ServiceIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

/// Sub-widget privado 2: Columna de título y descripción
class _ServiceTextDetails extends StatelessWidget {
  const _ServiceTextDetails({
    required this.title,
    required this.description,
    required this.titleColor,
    required this.subtitleColor,
  });

  final String title;
  final String description;
  final Color titleColor;
  final Color subtitleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w800,
            fontSize: 13,
          ),
        ),
        Text(
          description,
          style: TextStyle(color: subtitleColor, fontSize: 11),
        ),
      ],
    );
  }
}

/// Sub-widget privado 3: Badge de estado del servicio
class _ServiceStatusBadge extends StatelessWidget {
  const _ServiceStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF2A9D8F).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF2A9D8F),
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}
