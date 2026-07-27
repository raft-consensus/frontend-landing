import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Trae AppColors de core

/// ¿Qué hace?: Widget que renderiza el isotipo (icono de barco con gradiente) y el texto del logotipo "Raft DB".
/// ¿De dónde trae?: Consume AppColors de core/theme/app_colors.dart.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de DashboardSidebar y DashboardTopbar.
class RaftLogo extends StatelessWidget {
  const RaftLogo({
    this.small = false, // Define si el logo se dibuja compacto o tamaño normal
    super.key,
  });

  final bool small;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Insignia gráfica del isotipo (cuadro con gradiente azul-cyan e icono de almacenamiento/barco)
        Container(
          width: small ? 32 : 38,
          height: small ? 32 : 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(small ? 9 : 11),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.blue, // Azul de core
                AppColors.cyan, // Cyan de core
              ],
            ),
          ),
          child: Icon(
            Icons.sailing_rounded, // Icono gráfico del barco Raft
            color: Colors.white,
            size: small ? 19 : 23,
          ),
        ),
        const SizedBox(width: 10),
        // Texto con el nombre de la marca "Raft DB"
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: small ? 17 : 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Raft ',
                style: TextStyle(color: AppColors.navy), // Texto "Raft" en Azul Oscuro
              ),
              TextSpan(
                text: 'DB',
                style: TextStyle(color: AppColors.cyan), // Texto "DB" en Cyan de acento
              ),
            ],
          ),
        ),
      ],
    );
  }
}
