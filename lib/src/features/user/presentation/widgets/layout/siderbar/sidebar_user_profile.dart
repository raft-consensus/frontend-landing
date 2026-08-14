// ==========================================
// Qué hace: Tarjeta de perfil inferior que muestra iniciales, nombre, email del usuario y botón de cerrar sesión.
// Dónde se conecta: Se renderiza en el pie de DashboardSidebar.
// De dónde trae datos: Consume authProvider de Riverpod.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';

/// Tarjeta de perfil de usuario y control de sesión
class SidebarUserProfile extends ConsumerWidget {
  const SidebarUserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = ref.watch(authProvider);
    final user = authState.session?.user;

    final userName = user?.name ?? 'Usuario Raft';
    final userEmail = user?.email ?? 'user@raftdb.dev';

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

    final cardBg = isDark ? AppColors.nightCard : const Color(0xFFF7F9FC);
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final nameColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final emailColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          // Avatar con iniciales
          CircleAvatar(
            radius: 18,
            backgroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
            child: Text(
              initials,
              style: TextStyle(
                color: isDark ? AppColors.nightBackground : Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Nombre y Correo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                    color: nameColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: emailColor,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Botón Cerrar Sesión
          IconButton(
            onPressed: () async {
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
            icon: Icon(
              Icons.logout_rounded,
              size: 18,
              color: emailColor,
            ),
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
    );
  }
}
