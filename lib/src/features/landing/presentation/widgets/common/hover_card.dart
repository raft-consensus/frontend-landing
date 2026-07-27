import 'package:flutter/material.dart';

/// Widget wrapper reutilizable que añade animación suave de elevación y sombra (Efecto Hover).
/// 
/// ¿Qué hace?: Detecta el puntero del ratón y eleva el widget 'child' 6px hacia arriba con sombra dinámica.
/// ¿De dónde recibe datos?: Widget child, borderRadius y evento opcional onTap.
/// ¿Hacia dónde va / Dónde se conecta?: Enuelve tarjetas en DatabaseCard, MetricCard, BenefitCard, UseCaseCard, etc.
class HoverCard extends StatefulWidget {
  const HoverCard({
    required this.child,
    this.borderRadius = 16,
    this.showShadow = true,
    this.onTap,
    super.key,
  });

  /// Widget interno al que se le aplicará el efecto Hover (ej. Container de la tarjeta)
  final Widget child;

  /// Radio de curvatura de los bordes para coincidir con la tarjeta contenedora
  final double borderRadius;

  /// Callback opcional de clic al presionar la tarjeta
  final VoidCallback? onTap;
  
  final bool showShadow;

  @override
  State<HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  // Estado que rastrea si el puntero del ratón está actualmente sobre la tarjeta
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      // Cambia el puntero a cursor de mano interactiva al estar encima
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          // Eleva el widget 6 píxeles hacia arriba en el eje Y cuando _isHovered es verdadero
          transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: (_isHovered && widget.showShadow)
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
