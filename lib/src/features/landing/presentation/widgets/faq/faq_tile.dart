import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';

/// Componente de acordeón desplegable para una pregunta y respuesta frecuente.
/// 
/// ¿Qué hace?: Renderiza un contenedor estilizado con ExpansionTile para mostrar la pregunta y desplegar la respuesta.
/// ¿De dónde recibe datos?: String question y String answer provistos desde FaqSection.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado en la lista vertical de FaqSection.
class FaqTile extends StatelessWidget {
  const FaqTile({
    required this.question,
    required this.answer,
    super.key,
  });

  final String question;
  final String answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFD),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFE1EAF3),
        ),
      ),
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: AppColors.blue,
        collapsedIconColor: AppColors.navy,
        title: Text(
          question,
          style: const TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w800,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 0, 45, 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                answer,
                style: const TextStyle(
                  color: AppColors.muted,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
