import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

/// ¿Qué hace?: Texto estilizado en negrita para etiquetas de campos con soporte dinámico Día/Noche.
/// ¿De dónde trae datos?: Ingesta la etiqueta textual y responde al tema del sistema.
/// ¿Cómo se conecta?: Se coloca inmediatamente arriba de los inputs de formularios.
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Text(
      label,
      style: TextStyle(
        color: textColor,
        fontSize: 12,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}
