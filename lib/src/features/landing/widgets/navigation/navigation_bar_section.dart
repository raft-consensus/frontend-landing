import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/landing/widgets/common/raft_logo.dart';
import 'package:frontend_landing/src/features/landing/widgets/navigation/nav_link.dart';
import 'package:go_router/go_router.dart';

/// Barra de navegación superior (Header/Navbar) con comportamiento responsivo.
class NavigationBarSection extends StatelessWidget {
  const NavigationBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Color blanco semi-transparente (96% opacidad) para dar efecto de superposición suave
      color: Colors.white.withOpacity(0.96),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: Center(
        child: ConstrainedBox(
          // Ancho máximo contenido a 1180px igual que las demás secciones
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Condición responsiva: si el ancho es mayor a 850px se considera escritorio
              final desktop = constraints.maxWidth > 850;

              return Row(
                children: [
                  // 1. Logotipo de Raft DB ubicado a la izquierda
                  const RaftLogo(),

                  // 2. Empuja los siguientes elementos completamente hacia la derecha
                  const Spacer(),

                  // 3. Vista de Escritorio: Enlaces y botones directos
                  if (desktop) ...[
                    const NavLink('Bases de datos'),
                    const NavLink('Beneficios'),
                    const NavLink('Cómo funciona'),
                    const NavLink('FAQ'),
                    const SizedBox(width: 16),

                    // Botón secundario para Iniciar sesión
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('Iniciar sesión'),
                    ),

                    const SizedBox(width: 8),

                    // Botón primario relleno para Crear cuenta
                    FilledButton(
                      onPressed: () => context.go('/register'),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                      ),
                      child: const Text('Crear cuenta'),
                    ),
                  ]
                  // 4. Vista Móvil: Muestra un menú de hamburguesa
                  else
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu_rounded),
                      color: AppColors.navy,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
