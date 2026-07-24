import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Ilustración completa construida en Flutter puro (balsa, vela, discos de BD y olas).
class RaftIllustration extends StatelessWidget {
  const RaftIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      height: 450,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(42),
        border: Border.all(color: const Color(0xFFDCE9F5)),
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withOpacity(0.12),
            blurRadius: 45,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sol / Círculo decorativo
          Positioned(
            top: 35,
            right: 35,
            child: Container(
              width: 75,
              height: 75,
              decoration: const BoxDecoration(
                color: Color(0xFFE9FBFB),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Mastil de la balsa
          Positioned(
            top: 76,
            child: Container(
              width: 12,
              height: 220,
              decoration: BoxDecoration(
                color: const Color(0xFF8D552C),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Vela recortada con SailClipper
          Positioned(
            top: 82,
            left: 118,
            right: 52,
            child: ClipPath(
              clipper: SailClipper(),
              child: Container(
                height: 205,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Color(0xFFF4EBDD)],
                  ),
                ),
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Raft\nDB',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 42,
                        height: 0.9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Discos de servidor montados sobre la balsa
          Positioned(
            left: 48,
            bottom: 96,
            child: Column(
              children: const [
                ServerDisk(color: AppColors.cyan),
                ServerDisk(color: AppColors.blue),
                ServerDisk(color: Color(0xFF7047E8)),
                ServerDisk(color: Color(0xFF20B95A)),
              ],
            ),
          ),
          // Tronco / Base de la balsa
          Positioned(
            left: 62,
            right: 37,
            bottom: 70,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFF8D552C),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: AppColors.navy,
                  width: 5,
                ),
              ),
            ),
          ),
          // Olas debajo de la balsa
          const Positioned(
            left: 20,
            right: 20,
            bottom: 18,
            child: Icon(
              Icons.waves_rounded,
              color: AppColors.blue,
              size: 85,
            ),
          ),
        ],
      ),
    );
  }
}

/// Componente visual que simula un disco de servidor montado.
class ServerDisk extends StatelessWidget {
  const ServerDisk({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 112,
      height: 40,
      margin: const EdgeInsets.only(bottom: 3),
      padding: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.72), color],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.navy, width: 4),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CircleAvatar(radius: 3, backgroundColor: Colors.white),
          SizedBox(width: 5),
          CircleAvatar(radius: 3, backgroundColor: Colors.white),
        ],
      ),
    );
  }
}

/// Clipper personalizado para darle la forma curva a la vela del barco.
class SailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.85, 0)
      ..quadraticBezierTo(
        size.width,
        size.height * 0.45,
        size.width * 0.72,
        size.height,
      )
      ..lineTo(0, size.height * 0.90)
      ..quadraticBezierTo(
        size.width * 0.14,
        size.height * 0.45,
        0,
        0,
      )
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
