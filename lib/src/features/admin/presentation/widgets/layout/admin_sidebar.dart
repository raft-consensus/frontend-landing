import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/admin/domain/entities/sidebar_data.dart'; // Domain
import 'package:frontend_landing/src/features/admin/presentation/widgets/layout/admin_logo.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/layout/admin_sidebar_item.dart'; // Widget
import 'package:frontend_landing/src/features/admin/presentation/widgets/layout/admin_profile.dart'; // Widget


class AdminSidebar extends StatelessWidget {
  const AdminSidebar({
    required this.selectedIndex,
    required this.maintenanceMode,
    required this.onSelect,
    super.key,
  });

  final int selectedIndex;
  final bool maintenanceMode;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      SidebarData(Icons.dashboard_rounded, 'Resumen'),
      SidebarData(Icons.people_alt_rounded, 'Usuarios'),
      SidebarData(Icons.storage_rounded, 'Bases de datos'),
      SidebarData(Icons.smart_toy_rounded, 'IA'),
      SidebarData(Icons.hub_rounded, 'N8N'),
      SidebarData(Icons.dns_rounded, 'Infraestructura'),
      SidebarData(Icons.policy_rounded, 'Auditoría'),
      SidebarData(Icons.settings_rounded, 'Configuración'),
    ];

    return Container(
      color: AppColors.deepNavy,
      padding: const EdgeInsets.fromLTRB(16, 23, 16, 18),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AdminLogo(),
            const SizedBox(height: 34),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 7),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.purple.withValues(alpha: 0.13),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.purple.withValues(alpha: 0.22),
                ),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.admin_panel_settings_rounded,
                    color: Color(0xFF9B87FF),
                    size: 21,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Panel administrativo',
                      style: TextStyle(
                        color: Color(0xFFC8BEFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'ADMINISTRACIÓN',
                style: TextStyle(
                  color: Color(0xFF68809F),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...List.generate(
              items.length,
              (index) => AdminSidebarItem(
                data: items[index],
                selected: selectedIndex == index,
                onTap: () => onSelect(index),
              ),
            ),
            const Spacer(),
            if (maintenanceMode)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                  color: AppColors.orange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.orange.withValues(alpha: 0.23),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.construction_rounded,
                      color: AppColors.orange,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Mantenimiento activo',
                        style: TextStyle(
                          color: AppColors.orange,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const AdminProfile(),
          ],
        ),
      ),
    );
  }
}
