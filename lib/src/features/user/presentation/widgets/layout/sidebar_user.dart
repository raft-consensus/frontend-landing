import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';

/// ¿Qué hace?: Tarjeta gráfica inferior del Sidebar que muestra la sesión del usuario y permite cerrar sesión.
/// ¿De dónde trae?: Consume authProvider de Riverpod para obtener la sesión inmutable y el método logout().
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la parte inferior de DashboardSidebar.
class SidebarUser extends ConsumerWidget {
  const SidebarUser({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el estado de autenticación actual
    final authState = ref.watch(authProvider);
    final user = authState.session?.user;

    // Obtiene el nombre y correo real, o fallbacks elegantes si aún no han cargado
    final userName = user?.name ?? 'Usuario Raft';
    final userEmail = user?.email ?? 'user@raftdb.dev';

    // Genera las iniciales dinámicamente según el nombre (ej. "Andrés Cortés" -> "AC")
    final initials = userName.trim().isNotEmpty
        ? userName
            .trim()
            .split(' ')
            .where((word) => word.isNotEmpty)
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : 'RU';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar circular con las iniciales dinámicas del usuario
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.navy,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Nombre y correo del usuario autenticado
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userEmail,
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Botón gráfico de cerrar sesión
          IconButton(
            onPressed: () async {
              // Ejecuta el cierre de sesión real y limpia la sesión guardada
              await ref.read(authProvider.notifier).logout();

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada correctamente'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              size: 18,
              color: AppColors.muted,
            ),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }
}
