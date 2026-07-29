import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

/// Menú lateral desplegable (Drawer) para la navegación responsiva en dispositivos móviles y tablets.
///
/// ¿Qué hace?: Renderiza el listado de enlaces con iconos y botones de acceso en un panel deslizable.
/// ¿De dónde recibe datos?: Recibe los callbacks de desplazamiento vertical (onMetricsTap, etc.) desde LandingPage.
/// ¿Hacia dónde va / Dónde se conecta?: Utilizado en la propiedad endDrawer del Scaffold en LandingPage (landing_page.dart).
class LandingDrawer extends StatelessWidget {
  const LandingDrawer({
    this.onMetricsTap,
    this.onDatabasesTap,
    this.onBenefitsTap,
    this.onHowItWorksTap,
    this.onFaqTap,
    super.key,
  });

  final VoidCallback? onMetricsTap;
  final VoidCallback? onDatabasesTap;
  final VoidCallback? onBenefitsTap;
  final VoidCallback? onHowItWorksTap;
  final VoidCallback? onFaqTap;

  @override
  Widget build(BuildContext context) {
    // Menú desplegable lateral para pantallas móviles / tablets
    final drawerWidth = MediaQuery.of(context).size.width * 0.75;
    return Drawer(
      width: drawerWidth > 270 ? 270 : drawerWidth,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado con título del menú y botón para cerrar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Menú',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const Divider(height: 30),

              // Opción Métricas
              ListTile(
                leading: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.navy,
                ),
                title: const Text('Métricas'),
                onTap: () {
                  Navigator.pop(
                    context,
                  ); // Cierra el drawer antes de deslizarse
                  onMetricsTap?.call();
                },
              ),

              // Opción Bases de Datos
              ListTile(
                leading: const Icon(Icons.dns_rounded, color: AppColors.navy),
                title: const Text('Bases de datos'),
                onTap: () {
                  Navigator.pop(context);
                  onDatabasesTap?.call();
                },
              ),

              // Opción Beneficios
              ListTile(
                leading: const Icon(
                  Icons.star_outline_rounded,
                  color: AppColors.navy,
                ),
                title: const Text('Beneficios'),
                onTap: () {
                  Navigator.pop(context);
                  onBenefitsTap?.call();
                },
              ),

              // Opción Cómo Funciona
              ListTile(
                leading: const Icon(Icons.route_rounded, color: AppColors.navy),
                title: const Text('Cómo funciona'),
                onTap: () {
                  Navigator.pop(context);
                  onHowItWorksTap?.call();
                },
              ),

              // Opción FAQ
              ListTile(
                leading: const Icon(
                  Icons.help_outline_rounded,
                  color: AppColors.navy,
                ),
                title: const Text('FAQ'),
                onTap: () {
                  Navigator.pop(context);
                  onFaqTap?.call();
                },
              ),

              const Spacer(),

              // Botón Iniciar sesión
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // Padding vertical más compacto
                  ),
                  child: const Text('Iniciar sesión'),
                ),
              ),

              const SizedBox(height: 12),

              // Botón Crear cuenta
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/register');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                    ), // Padding vertical más compacto
                  ),
                  child: const Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
