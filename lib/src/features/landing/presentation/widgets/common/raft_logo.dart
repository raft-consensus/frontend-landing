import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// ¿Qué hace?: Widget que renderiza el isotipo (imagen de logo) y el texto "Raft DB".
/// ¿De dónde recibe?: Recibe el parámetro opcional `light` para alternar colores en fondos oscuros.
/// ¿Dónde se conecta?: Se importa en NavigationBarSection y FooterSection de la landing.
class RaftLogo extends StatelessWidget {
  const RaftLogo({super.key, this.light = false});

  /// Si es true, el texto "Raft" se muestra en blanco.
  final bool light;

  @override
  Widget build(BuildContext context) {
    // Determina el color del texto "Raft" según el fondo (claro u oscuro)
    final color = light ? Colors.white : AppColors.navy;

    return Row(
      mainAxisSize: MainAxisSize.min, // Ocupa únicamente el ancho del contenido
      children: [
        // Imagen del logo reemplazando el icono estático
        ClipRRect(
          borderRadius: BorderRadius.circular(13), // Bordes redondeados según diseño
          child: Image.asset(
            'lib/src/img/image_logo.png', // Ruta de la imagen declarada en pubspec.yaml
            width: 44, // Ancho fijo del logo
            height: 44, // Alto fijo del logo
            fit: BoxFit.cover, // Cubre el espacio manteniendo proporciones
          ),
        ),
        const SizedBox(width: 10), // Separación entre imagen y texto

        // Texto principal "Raft"
        Text(
          'Raft',
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(width: 3),

        // Texto secundario "DB"
        const Text(
          'DB',
          style: TextStyle(
            color: AppColors.cyan,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
