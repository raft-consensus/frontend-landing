import 'package:flutter/material.dart';

/// Modelo de datos simple que representa un paso del proceso 'Cómo Funciona'.
/// 
/// ¿Qué hace?: Guarda el número secuencial ('01', '02'...), icono, título y descripción del paso.
/// ¿De dónde recibe datos?: Instanciado en HowItWorksSection.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por StepCard para renderizar la UI.
class StepData {
  const StepData(this.number, this.icon, this.title, this.description);

  final String number;
  final IconData icon;
  final String title;
  final String description;
}
