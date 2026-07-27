import 'package:flutter/material.dart';

/// ¿Qué hace?: Tarjeta contenedora base con fondo blanco, bordes redondeados y sombra sutil para destacar información.
/// ¿Cómo se conecta?: Se usa como estructura envolvente para MetricCard, ToolCard, GuideCard y casi todas las secciones del panel.
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    required this.child,    // Componentes o textos que se ubicarán dentro de la tarjeta
    this.padding,           // Espacio interno (por defecto 20px alrededor)
    this.margin,            // Espacio exterior para separar de otros bloques
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    // Componente visual: Caja contenedora blanca con bordes curvos y sombra
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20), // Padding interno visible en monitor
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco puro para contraste con el fondo azul grisáceo
        borderRadius: BorderRadius.circular(16), // Curvatura suave en las 4 esquinas (16px)
        border: Border.all(
          color: const Color(0xFFE0E7F0), // Línea de borde gris muy fino alrededor de la tarjeta
        ),
        boxShadow: const [
          // Sombra inferior flotante para dar sensación de elevación en la pantalla
          BoxShadow(
            color: Color(0x08071D45), // Opacidad ligera para que no se vea recargado
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
