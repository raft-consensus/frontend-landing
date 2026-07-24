import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/register/feature_item.dart';

/// Panel lateral de presentación para la pantalla de registro en vista escritorio.
class RegisterPresentation extends StatelessWidget {
  const RegisterPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RaftLogo(light: true),
        SizedBox(height: 52),
        StatusPill(),
        SizedBox(height: 25),
        Text(
          'Tu próxima idea\ncomienza con datos.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 54,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -2,
          ),
        ),
        SizedBox(height: 22),
        Text(
          'Crea una cuenta gratuita y despliega bases de datos '
          'para tus prácticas, prototipos y proyectos de desarrollo.',
          style: TextStyle(
            color: Color(0xFFB4C5DA),
            fontSize: 17,
            height: 1.65,
          ),
        ),
        SizedBox(height: 35),
        FeatureItem(
          icon: Icons.bolt_rounded,
          title: 'Configuración rápida',
          description: 'Tu instancia estará lista en pocos minutos.',
        ),
        SizedBox(height: 18),
        FeatureItem(
          icon: Icons.storage_rounded,
          title: 'Cuatro motores disponibles',
          description: 'MySQL, PostgreSQL, SQL Server y MongoDB.',
        ),
        SizedBox(height: 18),
        FeatureItem(
          icon: Icons.shield_rounded,
          title: 'Entorno seguro',
          description: 'Credenciales independientes para cada instancia.',
        ),
      ],
    );
  }
}

/// Encabezado simplificado para dispositivos móviles.
class MobileBrand extends StatelessWidget {
  const MobileBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RaftLogo(light: true),
        SizedBox(height: 15),
        Text(
          'Crea tu cuenta gratuita',
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

/// Badge tipo cápsula de estado para indicar que el registro es gratuito.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.cyan.withOpacity(0.25),
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 4,
            backgroundColor: AppColors.cyan,
          ),
          SizedBox(width: 8),
          Text(
            'REGISTRO GRATUITO',
            style: TextStyle(
              color: AppColors.cyan,
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
