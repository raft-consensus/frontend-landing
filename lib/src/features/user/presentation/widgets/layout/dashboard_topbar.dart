import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/core/theme/theme_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/services_hub_dialog.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart';

/// ¿Qué hace?: Barra superior de navegación del Dashboard con título, conmutador de tema Día/Noche, notificaciones y acceso al Hub de Servicios.
/// ¿De dónde trae datos?: Sintoniza themeModeProvider (Riverpod) y recibe callbacks del DashboardPage.
/// ¿Hacia dónde va / Cómo se conecta?: Se posiciona en la parte superior fija del layout principal en DashboardPage.
class DashboardTopbar extends ConsumerWidget {
  final String title;                    // Título dinámico que cambia según la pestaña activa (ej: Resumen General)
  final VoidCallback onOpenDrawer;       // Callback para desplegar el menú hamburguesa lateral en pantallas móviles
  final VoidCallback onCreateDatabase;   // Callback para abrir el modal de aprovisionamiento de nueva Base de Datos
  final ValueChanged<int>? onSelectTab;   // Callback opcional para cambiar la pestaña activa desde el Hub de Servicios
  final void Function(String message, {bool success})? onMessage; // Receptor de mensajes SnackBar

  const DashboardTopbar({
    required this.title,            // Requerido: Título de la sección
    required this.onOpenDrawer,     // Requerido: Acción menú móvil
    required this.onCreateDatabase, // Requerido: Acción crear BD
    this.onSelectTab,               // Opcional: Selector de pestaña activa
    this.onMessage,                 // opcional:
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Determina si la pantalla actual tiene dimensiones de escritorio (ancho >= 900px)
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    // 2. Lee el modo de tema global (Raft Day vs Raft Night) desde el proveedor de Riverpod
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark; // Booleano: true si el tema oscuro está activo

    // 3. Define los colores dinámicos adaptados al tema visual activo
    final surfaceColor = isDark ? AppColors.nightSurface : AppColors.daySurface; // Fondo de la barra superior
    final borderColor = isDark ? AppColors.nightBorder : AppColors.dayBorder;     // Color de la línea inferior
    final iconColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color de los iconos interactivos
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary; // Color del título principal

    return Container(
      height: 70, // Altura fija estándar de la barra superior
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16), // Relleno lateral adaptativo
      decoration: BoxDecoration(
        color: surfaceColor,
        border: Border(
          bottom: BorderSide(color: borderColor), // Línea divisoria inferior discreta
        ),
      ),
      child: Row(
        children: [
          // Sección Izquierda: Botón Menú Hamburguesa (Móvil) o Título Principal (Escritorio)
          if (!isDesktop) ...[
            IconButton(
              onPressed: onOpenDrawer, // Abre el Drawer lateral en dispositivos móviles
              icon: Icon(Icons.menu_rounded, color: iconColor),
              tooltip: 'Abrir menú de navegación',
            ),
            const SizedBox(width: 8),
            const RaftLogo(small: true), // Muestra versión pequeña del logo en móvil
          ] else ...[
            Text(
              title, // Título de la página activa (ej: Resumen General, Mis Bases de Datos, etc.)
              style: TextStyle(
                color: titleColor,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],

          const Spacer(), // Empuja las acciones del extremo derecho hacia el final de la barra

          // Acción 1: Conmutador de Tema Visual (Raft Day / Raft Night)
          IconButton(
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme(); // Alterna entre modo claro y oscuro
            },
            icon: Icon(
              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: iconColor,
            ),
            tooltip: isDark ? 'Cambiar a Modo Claro (Raft Day)' : 'Cambiar a Modo Oscuro (Raft Night)',
          ),
          const SizedBox(width: 6),

          // Acción 2: Centro de Notificaciones del Sistema
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NotificationsDialog(), // Abre el modal de notificaciones
              );
            },
            icon: Icon(
              Icons.notifications_none_rounded,
              color: iconColor,
            ),
            tooltip: 'Notificaciones del sistema',
          ),
          const SizedBox(width: 10),

          // Acción 3: Botón Destacado "Ecosistema Raft" (Abre el Hub de Servicios y Atajos)
          FilledButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => ServicesHubDialog(
                  onCreateDatabase: onCreateDatabase, // Pasa el callback para crear bases de datos
                  onSelectTab: onSelectTab,           // Pasa el callback para cambiar de pestaña activa
                  onMessage: onMessage, // Pasa el receptor de mensajes al Hub
                ),
              );
            },
            icon: const Icon(Icons.language_rounded, size: 18),
            label: Text(isDesktop ? 'Ecosistema Raft' : 'Servicios'), // Etiqueta responsiva
            style: FilledButton.styleFrom(
              backgroundColor: isDark ? AppColors.nightPrimary : AppColors.dayPrimary,
              foregroundColor: isDark ? AppColors.nightBackground : Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 18 : 12,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
