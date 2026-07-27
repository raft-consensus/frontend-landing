import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/create_database_dialog.dart'; // Dialogs
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/notifications_dialog.dart'; // Dialogs
import 'package:frontend_landing/src/features/user/presentation/widgets/layout/raft_logo.dart'; // Layout

/// ¿Qué hace?: Barra superior responsiva con buscador, campana de notificaciones, botón "Nueva Base de Datos" y menú hamburguesa para móvil.
/// ¿De dónde trae?: Trae AppColors (core), CreateDatabaseDialog y NotificationsDialog (dialogs), y RaftLogo (layout).
/// ¿Hacia dónde va / Cómo se conecta?: Se coloca en la parte superior de DashboardPage.
class DashboardTopbar extends StatelessWidget {
  const DashboardTopbar({
    required this.title,           // Título de la página activa en pantalla
    required this.onOpenDrawer,    // Callback para abrir el menú lateral en pantallas móviles
    required this.onCreateDatabase,// Callback al crear una nueva BD desde el botón superior
    super.key,
  });

  final String title;
  final VoidCallback onOpenDrawer;
  final VoidCallback onCreateDatabase;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Container(
      height: 70, // Altura fija de 70px
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 28 : 16),
      decoration: const BoxDecoration(
        color: Colors.white, // Fondo blanco plano
        border: Border(
          bottom: BorderSide(color: AppColors.border), // Borde inferior separador
        ),
      ),
      child: Row(
        children: [
          // En pantallas móviles/tablets (isDesktop = false), muestra el botón de menú hamburguesa
          if (!isDesktop) ...[
            IconButton(
              onPressed: onOpenDrawer, // Abre el Drawer de navegación
              icon: const Icon(Icons.menu_rounded, color: AppColors.navy),
            ),
            const SizedBox(width: 8),
            const RaftLogo(small: true), // Muestra el logo compacto en móvil
          ] else ...[
            // En pantallas de escritorio muestra el título grande de la sección activa
            Text(
              title,
              style: const TextStyle(
                color: AppColors.navy,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],

          const Spacer(), // Empuja los elementos siguientes a la derecha

          // Campo gráfico de búsqueda (Buscador)
          if (isDesktop)
            SizedBox(
              width: 240,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar en el panel...',
                  hintStyle: const TextStyle(fontSize: 12, color: AppColors.muted),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.muted),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  fillColor: const Color(0xFFF7F9FC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.border)),
                ),
              ),
            ),
          const SizedBox(width: 12),

          // Botón de campana para abrir el modal NotificationsDialog
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const NotificationsDialog(), // Llama a NotificationsDialog de dialogs/
              );
            },
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.navy),
            tooltip: 'Notificaciones',
          ),
          const SizedBox(width: 8),

          // Botón principal azúl "+ Nueva Base de Datos" que abre CreateDatabaseDialog
          FilledButton.icon(
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => const CreateDatabaseDialog(), // Llama a CreateDatabaseDialog de dialogs/
              );

              if (result != null) {
                onCreateDatabase(); // Notifica la creación a la página principal
              }
            },
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(isDesktop ? 'Nueva base de datos' : 'Nueva'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.navy,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 18 : 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
