// ==========================================
// Archivo: lib/src/features/landing/presentation/widgets/common/section_container.dart
// ¿Qué hace?: Widget contenedor que estandariza el padding y el ancho máximo de cada sección de la Landing Page.
// ¿De dónde trae datos?: Ingesta el widget hijo y un color de fondo opcional (si no se envía, usa el tema activo).
// ¿Hacia dónde va / Cómo se conecta?: Envolvente primario usado por casi todas las secciones de la Landing.
// ==========================================

import 'package:flutter/material.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.child,
    this.background,
    super.key,
  });

  /// El contenido interno específico de la sección (filas, columnas, tarjetas, etc.).
  final Widget child;

  /// El color de fondo de la sección (opcional, por defecto usa scaffoldBackgroundColor del tema).
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final bgColor = background ?? Theme.of(context).scaffoldBackgroundColor;

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 88,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: child,
        ),
      ),
    );
  }
}
