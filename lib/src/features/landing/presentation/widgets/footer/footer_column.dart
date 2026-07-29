import 'package:flutter/material.dart';

/// Columna individual de enlaces de navegación para el pie de página.
/// 
/// ¿Qué hace?: Renderiza un título destacado en blanco y una lista de enlaces verticales.
/// ¿De dónde recibe datos?: String title y `List<String>` links desde FooterSection.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado dentro del Wrap de columnas en FooterSection.
class FooterColumn extends StatelessWidget {
  const FooterColumn({
    required this.title,
    required this.links,
    super.key,
  });

  final String title;
  final List<String> links;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 135,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la columna
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),

          // Enlaces verticales de navegación
          ...links.map(
            (link) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Text(
                link,
                style: const TextStyle(
                  color: Color(0xFF91A5BE),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
