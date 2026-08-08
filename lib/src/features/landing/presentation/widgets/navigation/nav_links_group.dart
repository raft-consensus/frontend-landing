import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/nav_link.dart';

/// ¿Qué hace?: Grupo central de enlaces de navegación por scroll para la barra superior (Navbar) en escritorio.
/// ¿De dónde trae datos?: Ingesta callbacks de scroll vertical enviados desde NavigationBarSection.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado en la sección central de NavigationBarSection.
class NavLinksGroup extends StatelessWidget {
  const NavLinksGroup({
    this.onMetricsTap,
    this.onDatabasesTap,
    this.onBenefitsTap,
    this.onHowItWorksTap,
    this.onFaqTap,
    super.key,
  });

  final VoidCallback? onMetricsTap; // Callback scroll métricas
  final VoidCallback? onDatabasesTap; // Callback scroll servicios
  final VoidCallback? onBenefitsTap; // Callback scroll beneficios
  final VoidCallback? onHowItWorksTap; // Callback scroll cómo funciona
  final VoidCallback? onFaqTap; // Callback scroll preguntas frecuentes

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavLink('Métricas', onTap: onMetricsTap),
        NavLink('Servicios', onTap: onDatabasesTap),
        NavLink('Beneficios', onTap: onBenefitsTap),
        NavLink('Cómo funciona', onTap: onHowItWorksTap),
        NavLink('FAQ', onTap: onFaqTap),
      ],
    );
  }
}
