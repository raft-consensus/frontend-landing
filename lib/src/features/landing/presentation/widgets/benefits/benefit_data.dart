import 'package:flutter/material.dart';

/// Modelo de datos simple que representa la información de un beneficio.
/// 
/// ¿Qué hace?: Define la estructura del icono, título, descripción y color de cada beneficio.
/// ¿De dónde recibe datos?: Instanciado en BenefitsSection.
/// ¿Hacia dónde va / Dónde se conecta?: Consumido por BenefitCard para construir la UI.
class BenefitData {
  const BenefitData(this.icon, this.title, this.description, this.color);

  final IconData icon;
  final String title;
  final String description;
  final Color color;
}
