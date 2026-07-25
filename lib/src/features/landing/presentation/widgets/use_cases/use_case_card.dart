import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';

/// Tarjeta individual para presentar un caso de uso (Estudiantes, Developers, Docentes).
/// 
/// ¿Qué hace?: Renderiza un avatar circular con icono coloreado, título y descripción centrada.
/// ¿De dónde recibe datos?: Objeto BenefitData (icono, título, descripción, color) y ancho deseado.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado dentro de UseCasesSection.
class UseCaseCard extends StatelessWidget {
  const UseCaseCard({
    required this.width,
    required this.data,
    super.key,
  });

  final double width;
  final BenefitData data;

  @override
  Widget build(BuildContext context) {
    return HoverCard(
      borderRadius: 22,
      child: Container(
        width: width,
        padding: const EdgeInsets.all(27),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFDFE9F3)),
        ),
        child: Column(
          children: [
            // Icono circular con color transparente según el perfil
            CircleAvatar(
              radius: 33,
              backgroundColor: data.color.withValues(alpha: 0.12),
              child: Icon(data.icon, color: data.color, size: 31),
            ),
            const SizedBox(height: 18),
      
            // Perfil objetivo
            Text(
              data.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 9),
      
            // Descripción breve
            Text(
              data.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
