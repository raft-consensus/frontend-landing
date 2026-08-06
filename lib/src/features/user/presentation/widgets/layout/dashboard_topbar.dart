import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';

/// ¿Qué hace?: Barra superior responsiva con botón principal del Ecosistema Raft, Toggle de Tema y Notificaciones.
/// ¿De dónde trae?: Consume themeModeProvider (Riverpod), ServicesHubDialog, NotificationsDialog y RaftLogo.
/// ¿Hacia dónde va / Cómo se conecta?: Renderizado en la parte superior de DashboardPage.
class DashboardTopbar extends ConsumerWidget {
  const DashboardTopbar({
    required this.title,
    required this.onOpenDrawer,
    required this.onCreateDatabase,
    super.key,
  });

  final String title;
  final VoidCallback onOpenDrawer;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : AppColors.border,
          ),
        ),
      ),
      child: Row(
        children: [
          // Menú hamburguesa y logo compacto en móvil
          if (!isDesktop) ...[
            IconButton(
              onPressed: onOpenDrawer,
              icon: const Icon(Icons.menu_rounded, color: AppColors.navy),
            ),
            const SizedBox(width: 8),
            const RaftLogo(small: true),
          ] else ...[
            // Título principal en escritorio
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.navy,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],

          const Spacer(),

          // 1. Botón Toggle Modo Claro / Oscuro
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: AppColors.navy,
            ),
            tooltip: isDark ? 'Cambiar a Modo Claro' : 'Cambiar a Modo Oscuro',
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
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.navy,
            ),
            tooltip: 'Notificaciones',
          ),
          const SizedBox(width: 10),

          // 3. Botón Principal "Ecosistema Raft" que reemplaza la barra y abre el Hub de Servicios
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    ServicesHubDialog(onCreateDatabase: onCreateDatabase),
              );
            },
            icon: const Icon(Icons.apps_rounded, size: 18),
            label: Text(isDesktop ? 'Ecosistema Raft' : 'Servicios'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
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
