import 'package:flutter/material.dart';

/// ¿Qué hace?: Tarjeta contenedora base con fondo, bordes redondeados y sombra sutil adaptados al tema Raft Day / Raft Night.
/// ¿De dónde recibe datos?: Ingesta la propiedad child y padding/margin opcionales, adaptando sus colores con Theme.of(context).
/// ¿Cómo se conecta?: Se usa como estructura envolvente para MetricCard, DatabaseManagementCard y casi todas las tarjetas del panel.
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
    // Obtención de las propiedades del tema activo en MaterialApp
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Componente visual: Caja contenedora adaptativa con bordes curvos y sombra
    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(20), // Padding interno visible
      decoration: BoxDecoration(
        color: theme.cardColor, // Fondo dinámico (Blanco en Day, Ocean Night en Night)
        borderRadius: BorderRadius.circular(16), // Curvatura suave de 16px
        border: Border.all(
          color: theme.dividerColor, // Borde gris suave en claro, navy gray en oscuro
        ),
        boxShadow: [
          // Sombra inferior adaptada al brillo
          BoxShadow(
            color: isDark 
                ? Colors.black.withValues(alpha: 0.30) // Sombra profunda en modo oscuro
                : const Color(0x08071D45),             // Opacidad ligera en modo claro
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
