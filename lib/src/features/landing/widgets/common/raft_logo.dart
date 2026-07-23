import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Widget de logotipo oficial de Raft DB.
class RaftLogo extends StatelessWidget {
  const RaftLogo({super.key, this.light = false});

  /// Si es true, el texto "Raft" se muestra en blanco (para usar en el Footer u otro fondo oscuro).
  final bool light;

  @override
  Widget build(BuildContext context) {
    // Determina el color del texto "Raft" según la variante (clara u oscura)
    final color = light ? Colors.white : AppColors.navy;

    return Row(
      mainAxisSize: MainAxisSize.min, // Ocupa únicamente el ancho del contenido interno
      children: [
        // Caja de icono del logo con degradado de color cyan a blue
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.cyan, AppColors.blue],
            ),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.sailing_rounded, // Icono del velero/balsa
            color: Colors.white,
            size: 27,
          ),
        ),
        const SizedBox(width: 10),

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

        // Texto secundario "DB" en color Cyan destacado
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
