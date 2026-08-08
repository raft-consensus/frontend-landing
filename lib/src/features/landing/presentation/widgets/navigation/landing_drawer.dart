// ==========================================
// ¿Qué hace?: Contenedor orquestador del menú lateral móvil (Drawer) desacoplado y ultra-liviano.
// ¿De dónde trae datos?: Recibe callbacks de scroll desde LandingPage.
// ¿Hacia dónde va / Cómo se conecta?: Se asigna en endDrawer del Scaffold en LandingPage.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/presentation/widgets/navigation/drawer_nav_tiles.dart';
import 'package:go_router/go_router.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final drawerWidth = MediaQuery.of(context).size.width * 0.75;

    return Drawer(
      width: drawerWidth > 270 ? 270 : drawerWidth,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Menú', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const Divider(height: 30),
              DrawerNavTiles(
                primaryColor: primaryColor,
                isDark: isDark,
                onMetricsTap: onMetricsTap,
                onDatabasesTap: onDatabasesTap,
                onBenefitsTap: onBenefitsTap,
                onHowItWorksTap: onHowItWorksTap,
                onFaqTap: onFaqTap,
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () { Navigator.pop(context); context.push('/login'); },
                  child: const Text('Iniciar sesión'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () { Navigator.pop(context); context.push('/register'); },
                  style: FilledButton.styleFrom(backgroundColor: primaryColor),
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
