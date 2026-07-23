import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget contenedor que estandariza el padding y ancho máximo de cada sección de la Landing Page.
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    this.background = AppColors.background,
    super.key,
  });

  /// El contenido interno específico de la sección (filas, columnas, tarjetas, etc.).
  final Widget child;

  /// El color de fondo de la sección (por defecto usa el background claro de la app).
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Ocupa todo el ancho disponible en la pantalla
      width: double.infinity,
      color: background,
      // Padding uniforme: 24px en los lados para móvil y 88px arriba/abajo para separar secciones
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 88,
      ),
      child: Center(
        // Centra el contenido dentro del contenedor horizontalmente
        child: ConstrainedBox(
          // Restringe el ancho del contenido interno a un máximo de 1180px para buena maquetación web
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}
