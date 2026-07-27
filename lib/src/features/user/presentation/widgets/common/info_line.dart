import 'package:flutter/material.dart';

/// ¿Qué hace?: Fila que alinea horizontalmente un icono descriptivo, una etiqueta de texto y su valor resultante.
/// ¿Cómo se conecta?: Se utiliza en tarjetas de BD para desplegar datos de conexión (Host, Puerto, Usuario, etc.).
class InfoLine extends StatelessWidget {
  const InfoLine({
    required this.icon,  // Icono descriptivo a la izquierda (ej. Icons.dns)
    required this.label, // Nombre del dato (ej. "Host")
    required this.value, // Valor a mostrar (ej. "pg01.raftdb.dev")
    super.key,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    // Estructura en fila horizontal que distribuye los elementos de izquierda a derecha
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF687A91), size: 17), // Icono gris pequeño de 17px
        const SizedBox(width: 9),
        // Etiqueta del nombre del campo
        Text(
          '$label:',
          style: const TextStyle(
            color: Color(0xFF687A91),
            fontSize: 11,
          ),
        ),
        const SizedBox(width: 7),
        // Valor numérico o texto a la derecha
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis, // Si el texto es más largo que la pantalla, lo recorta con "..."
            textAlign: TextAlign.right,      // Alineado a la derecha del contenedor
            style: const TextStyle(
              color: Color(0xFF152640),
              fontSize: 11,
              fontWeight: FontWeight.w700,  // Letra más gruesa para destacar el valor
            ),
          ),
        ),
      ],
    );
  }
}
