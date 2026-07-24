import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/platform_preview.dart';

/// Panel lateral de presentación para la pantalla de Login en vista escritorio.
class LoginPresentation extends StatelessWidget {
  const LoginPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RaftLogo(light: true),
        const SizedBox(height: 58),
        const StatusPill(),
        const SizedBox(height: 25),
        const Text(
          'Regresa a bordo\ny sigue construyendo.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 52,
            height: 1.06,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 525),
          child: const Text(
            'Accede a tus instancias, credenciales y herramientas '
            'desde un panel diseñado para trabajar sin complicaciones.',
            style: TextStyle(
              color: Color(0xFFB4C5DA),
              fontSize: 17,
              height: 1.65,
            ),
          ),
        ),
        const SizedBox(height: 38),
        const PlatformPreview(),
      ],
    );
  }
}

/// Encabezado simplificado para vista móvil en pantalla de Login.
class MobileBrand extends StatelessWidget {
  const MobileBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RaftLogo(light: true),
        SizedBox(height: 15),
        Text(
          'Accede a tu panel de Raft DB',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFB4C5DA),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

/// Badge tipo cápsula de estado con color verde para indicar disponibilidad de servicios.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF17B778).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF17B778).withOpacity(0.25),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: Color(0xFF17B778),
          ),
          SizedBox(width: 8),
          Text(
            'SERVICIOS DISPONIBLES',
            style: TextStyle(
              color: Color(0xFF17B778),
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
