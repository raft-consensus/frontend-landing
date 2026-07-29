import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart'; // Provider de auth

/// Tarjeta inferior del Sidebar de Admin: avatar, nombre, rol y botón de logout.
///
/// ¿De dónde recibe datos?: Consume authProvider (Riverpod) para ejecutar el logout.
/// ¿Hacia dónde va?: Al pulsar el ícono, cierra sesión y redirige a la landing page ('/').
class AdminProfile extends ConsumerWidget {
  const AdminProfile({super.key});

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    // 1. Cierra la sesión: borra el token y actualiza el estado global de auth.
    await ref.read(authProvider.notifier).logout();

    // 2. Verifica que el widget siga montado antes de navegar.
    if (!context.mounted) return;

    // 3. Redirige a la landing page.
    context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF18375F),
          child: Text(
            'RA',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Raft Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Superadministrador',
                style: TextStyle(
                  color: Color(0xFF7F94AE),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => _handleLogout(context, ref),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.logout_rounded,
                color: Color(0xFF8094AD),
                size: 19,
              ),
            ),
          ),
        ),
      ],
    );
  }
}