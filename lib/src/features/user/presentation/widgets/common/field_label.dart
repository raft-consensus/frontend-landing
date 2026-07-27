import 'package:flutter/material.dart';

/// ¿Qué hace?: Texto estilizado en negrita que actúa como título superior para campos de entrada de texto (TextField).
/// ¿Cómo se conecta?: Se coloca inmediatamente arriba de los inputs de formularios (en CreateDatabaseDialog o AccountPage).
class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});

  final String label; // Nombre visible del campo (ej. "Nombre de la base de datos")

  @override
  Widget build(BuildContext context) {
    // Texto formateado en pantalla con tono oscuro de alta legibilidad
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF152640), // Tono azul oscuro/negro para que resalte
        fontSize: 12,
        fontWeight: FontWeight.w800, // Negrita marcada para identificar rápido el campo
      ),
    );
  }
}
