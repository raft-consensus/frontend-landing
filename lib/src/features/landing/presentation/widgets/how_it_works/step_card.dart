import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/how_it_works/step_data.dart';

/// Tarjeta individual para presentar un paso con badge numérico y gradiente.
/// 
/// ¿Qué hace?: Renderiza la caja de icono con gradiente Cyan/Blue y un badge flotante con el número de paso.
/// ¿De dónde recibe datos?: Instancia de StepData y ancho deseado (width).
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado en el Wrap de HowItWorksSection.
class StepCard extends StatelessWidget {
  const StepCard({
    required this.width,
    required this.data,
    super.key,
  });

  final double width;
  final StepData data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        children: [
          // Caja de icono con gradiente y badge numérico superpuesto en la esquina superior derecha
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.cyan, AppColors.blue],
                  ),
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Icon(data.icon, color: Colors.white, size: 34),
              ),
              Positioned(
                top: -9,
                right: -9,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: AppColors.navy,
                  child: Text(
                    data.number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 21),

          // Título del paso
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),

          // Descripción explicativa
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
    );
  }
}
