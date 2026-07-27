import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/presentation/widgets/common/status_chip.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/dialogs/admin_alerts_dialog.dart'; // Widget


class AdminTopbar extends StatelessWidget {
  const AdminTopbar({
    required this.title,
    required this.desktop,
    required this.maintenanceMode,
    required this.onMessage,
    super.key,
  });

  final String title;
  final bool desktop;
  final bool maintenanceMode;
  final void Function(String, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (!desktop) ...[
              Builder(
                builder: (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  icon: const Icon(Icons.menu_rounded),
                ),
              ),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: desktop ? 20 : 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (maintenanceMode && desktop) ...[
              const StatusChip(
                label: 'Mantenimiento',
                color: AppColors.orange,
                icon: Icons.construction_rounded,
              ),
              const SizedBox(width: 12),
            ],
            if (desktop) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 9,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2FAF7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFD5EEE5),
                  ),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(
                      radius: 4,
                      backgroundColor: AppColors.green,
                    ),
                    SizedBox(width: 7),
                    Text(
                      'Sistemas operativos',
                      style: TextStyle(
                        color: Color(0xFF287558),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
            ],
            Badge(
              label: const Text('4'),
              child: IconButton(
                tooltip: 'Alertas',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AdminAlertsDialog(),
                  );
                },
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ),
            const SizedBox(width: 5),
            PopupMenuButton<String>(
              tooltip: 'Opciones administrativas',
              onSelected: (value) {
                onMessage(
                  value == 'logout'
                      ? 'Cerrando sesión administrativa...'
                      : 'Abriendo perfil administrativo...',
                );
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Perfil administrativo'),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Cerrar sesión'),
                ),
              ],
              child: const CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFE0EDFB),
                child: Text(
                  'RA',
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
