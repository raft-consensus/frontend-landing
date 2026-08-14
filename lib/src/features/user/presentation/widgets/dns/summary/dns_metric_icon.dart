// ==========================================
// Qué hace: Insignia atómica del icono de la métrica DNS con fondo translúcido y micro-animación hover.
// Dónde se conecta: Consumido internamente por DnsMetricCard.
// De dónde trae datos: Recibe el icono, color distintivo y el estado reactivo isHovered.
// ==========================================

import 'package:flutter/material.dart';

/// Icono estilizado con resplandor reactivo para métricas DNS
class DnsMetricIcon extends StatelessWidget {
  const DnsMetricIcon({
    required this.icon, // Icono a dibujar
    required this.iconColor, // Color temático del servicio
    required this.isHovered, // Estado de hover para intensificar el fondo
    super.key,
  });

  final IconData icon; // Icono
  final Color iconColor; // Color distintivo
  final bool isHovered; // Bandera de hover

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: isHovered ? 0.22 : 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }
}
