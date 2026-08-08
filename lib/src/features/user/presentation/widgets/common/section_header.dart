import 'package:flutter/material.dart';

/// ¿Qué hace?: Encabezado estandarizado para secciones de la UI con título responsivo al tema, subtítulo y botón de acción opcional.
/// ¿De dónde recibe datos?: Recibe el título, subtítulo, etiqueta de acción y callback onPressed.
/// ¿Cómo se conecta?: Se ubica en la parte superior de las páginas (DatabasesPage, OverviewPage, etc.).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.title, // Texto grande en pantalla (ej. "Gestión de Bases de Datos")
    required this.subtitle, // Explicación secundaria en letra pequeña gris
    this.actionLabel, // Texto visible del botón (ej. "Nueva BD")
    this.actionIcon, // Icono que acompaña al botón
    this.onAction, // Evento que se dispara al hacer clic
    super.key,
  });

  final String title;
  final String subtitle;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    // Extrae los estilos y colores del tema actual
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Estructura visual: Fila horizontal que distribuye el texto a la izquierda y el botón a la derecha
    return Row(
      children: [
        // Columna con los textos alineados a la izquierda
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Texto principal del título con color del tema activo
              Text(
                title,
                style: TextStyle(
                  color:
                      textTheme.titleLarge?.color ??
                      theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w900, // Letra extra negrita destacada
                ),
              ),
              const SizedBox(height: 4), // Separación vertical de 4px
              // Subtítulo explicativo
              Text(
                subtitle,
                style: TextStyle(
                  color: textTheme
                      .bodyMedium
                      ?.color, // Color secundario adaptado a día/noche
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        // Botón gráfico de acción interactivo (solo se dibuja si se proporcionan la etiqueta y la acción)
        if (actionLabel != null && onAction != null)
          actionIcon == null
              ? TextButton(
                  onPressed: onAction, // Evento de clic
                  child: Text(actionLabel!),
                )
              : FilledButton.icon(
                  onPressed: onAction, // Evento de clic
                  icon: Icon(
                    actionIcon,
                    size: 18,
                  ), // Icono visible dentro del botón
                  label: Text(actionLabel!), // Texto del botón
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        theme.colorScheme.primary, // Color de acento primario
                    foregroundColor:
                        theme.colorScheme.onPrimary, // Texto de alto contraste
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
      ],
    );
  }
}
