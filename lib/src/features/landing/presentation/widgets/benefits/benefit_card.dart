import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/benefits/benefit_data.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/common/hover_card.dart';

/// Tarjeta individual translúcida para presentar un beneficio sobre fondo oscuro.
/// 
/// ¿Qué hace?: Renderiza el icono coloreado, el título y la descripción del beneficio.
/// ¿De dónde recibe datos?: Recibe un objeto BenefitData y el ancho deseado (width).
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado dentro del Wrap en BenefitsSection.
class BenefitCard extends StatelessWidget {
  const BenefitCard({
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
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          // Transparencia con el estándar withValues(alpha: ...)
          color: Colors.white.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contenedor del icono con transparencia del color principal
            Container(
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                color: data.color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(data.icon, color: data.color),
            ),
            const SizedBox(height: 19),
      
            // Título del beneficio
            Text(
              data.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
      
            // Descripción breve
            Text(
              data.description,
              style: const TextStyle(
                color: Color(0xFFB8C8DD),
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
