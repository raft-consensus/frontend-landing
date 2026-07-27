import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Importación de la paleta central de colores (core)

/// ¿Qué hace?: Encabezado estandarizado para secciones de la UI con título en negrita, subtítulo y un botón de acción opcional.
/// ¿Cómo se conecta?: Se coloca en la parte superior de los bloques visuales (ej. "Tus Instancias", "Herramientas"). Usa AppColors de core.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title,       // Texto grande en pantalla (ej. "Bases de Datos Activas")
    required this.subtitle,    // Explicación secundaria en letra pequeña gris
    this.actionLabel,          // Texto visible del botón (ej. "Crear nueva")
    this.actionIcon,           // Icono que acompaña al botón
    this.onAction,             // Evento que se dispara al hacer clic/tap en el botón
    super.key,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Estructura visual: Fila horizontal que distribuye el texto a la izquierda y el botón a la derecha
    return Row(
      children: [
        // Columna con los textos alineados a la izquierda
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto principal del título
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.navy, // Usa el color navy (Azul Oscuro) de la carpeta core
                  fontSize: 20,
                  fontWeight: FontWeight.w900, // Letra extra negrita destacada
                ),
              ),
              const SizedBox(height: 4), // Separación vertical de 4px
              // Subtítulo explicativo
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF687A91), // Tono gris para menor jerarquía visual
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Botón gráfico de acción interactivo (solo se dibuja si se envían los datos del botón)
        if (actionLabel != null && onAction != null)
          actionIcon == null
              ? TextButton(
                  onPressed: onAction, // Evento de clic
                  child: Text(actionLabel!),
                )
              : FilledButton.icon(
                  onPressed: onAction, // Evento de clic
                  icon: Icon(actionIcon, size: 18), // Icono visible dentro del botón
                  label: Text(actionLabel!), // Texto del botón
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy, // Fondo azul oscuro reutilizado de core
                    foregroundColor: Colors.white,   // Texto e icono en blanco
                  ),
                ),
      ],
    );
  }
}
