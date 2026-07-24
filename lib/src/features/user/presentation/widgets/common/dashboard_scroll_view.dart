import 'package:flutter/material.dart';

/// ¿Qué hace?: Widget contenedor que da desplazamiento vertical suave y paddings adaptativos según el tamaño de la pantalla.
/// ¿Cómo se conecta?: Envuelve el contenido de las páginas principales (Overview, Databases, Tools, Documentation, Account).
class DashboardScrollView extends StatelessWidget {
  const DashboardScrollView({
    required this.child, // Recibe la página o vista completa que se va a renderizar adentro
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Gráfico/Lógica responsiva: Detectamos si la pantalla es de PC/Laptop (ancho >= 900px)
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // Componente visual: ScrollView permite deslizar el contenido verticalmente cuando no cabe en pantalla
    return SingleChildScrollView(
      // Espaciado en pantalla: 24px arriba/abajo, y lateral adaptativo (28px en PC, 16px en celular)
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28 : 16,
        vertical: 24,
      ),
      child: child,
    );
  }
}
