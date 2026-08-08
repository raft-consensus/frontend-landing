import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';

/// ¿Qué hace?: Barra superior responsiva con título, toggle de tema (Raft Day / Raft Night), notificaciones y hub de servicios.
/// ¿De dónde trae datos?: Sintoniza themeModeProvider (Riverpod) y consulta MediaQuery para la responsividad.
/// ¿Hacia dónde va / Cómo se conecta?: Se renderiza en la parte superior de DashboardPage.
class DashboardTopbar extends ConsumerWidget {
  const DashboardTopbar({
    required this.title,            // Título de la pestaña activa (ej: Resumen General)
    required this.onOpenDrawer,     // Acción para abrir el menú lateral en dispositivos móviles
    required this.onCreateDatabase, // Callback para abrir el modal de creación de BD
    super.key,
  });

  final String title;
  final VoidCallback onOpenDrawer;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Determina si la pantalla es de tamaño de escritorio (>= 900px)
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // 2. Lee el modo de tema actual desde Riverpod
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    // 3. Define los colores dinámicos según el tema activo
    final surfaceColor = isDark ? AppColors.nightSurface : AppColors.daySurface;
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;
    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: borderColor), // Línea divisoria inferior
        ),
      ),
      child: Row(
        children: [
          // Sección izquierda: Menú hamburguesa (móvil) o Título de la página (escritorio)
          if (!isDesktop) ...[
            IconButton(
              onPressed: onOpenDrawer,
              icon: Icon(Icons.menu_rounded, color: iconColor),
            ),
            const SizedBox(width: 8),
            const RaftLogo(small: true),
          ] else ...[
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],

          const Spacer(),

          // 1. Botón de Toggle para alternar entre Raft Day (Claro) y Raft Night (Oscuro)
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: iconColor,
            ),
            tooltip: isDark ? 'Cambiar a Modo Claro (Raft Day)' : 'Cambiar a Modo Oscuro (Raft Night)',
          ),
          const SizedBox(width: 6),

          // 2. Botón de Notificaciones
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NotificationsDialog(),
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: iconColor,
            ),
            tooltip: 'Notificaciones',
          ),
          const SizedBox(width: 10),

          // 3. Botón Principal "Ecosistema Raft" (Abre el Hub de Servicios)
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ServicesHubDialog(onCreateDatabase: onCreateDatabase),
              );
            },
            icon: const Icon(Icons.language_rounded, size: 18),
            label: Text(isDesktop ? 'Ecosistema Raft' : 'Servicios'),
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
              foregroundColor: isDark ? AppColors.nightBackground : Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 18 : 12,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
