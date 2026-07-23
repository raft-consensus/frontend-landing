import 'package:flutter/material.dart';

/// ¿Qué hace?: Widget visual para renderizar la insignia gráfica con el icono y color distintivo de un motor de BD.
/// ¿Cómo se conecta?: Se incluye en las tarjetas de bases de datos para identificar el motor visualmente en pantalla.
class EngineIcon extends StatelessWidget {
  const EngineIcon({
    required this.icon,   // Icono del motor (proviene de engineStyle)
    required this.color,  // Color institucional (proviene de engineStyle)
    this.small = false,   // Define si el tamaño gráfico es reducido (40px) o grande (48px)
    super.key,
  });

  final IconData icon;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    // Dimensión en píxeles que ocupará la caja en pantalla
    final size = small ? 40.0 : 48.0;

    return Container(
      width: size,
      height: size,
      // Caja cuadrada con esquinas suavemente redondeadas y fondo pastel translúcido
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11), // 11% de opacidad para dar tono suave de fondo
        borderRadius: BorderRadius.circular(small ? 12 : 14),
      ),
      // Icono nítido dibujado al centro de la caja con el color de marca al 100%
      child: Icon(
        icon,
        color: color,
        size: small ? 21 : 25,
      ),
    );
  }
}
