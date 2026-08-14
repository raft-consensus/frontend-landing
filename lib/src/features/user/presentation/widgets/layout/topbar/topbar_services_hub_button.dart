// ==========================================
// Qué hace: Botón destacado de acceso rápido al modal de Ecosistema Raft (Hub de Servicios y Atajos).
// Dónde se conecta: Consumido por DashboardTopbar.
// De dónde trae datos: Recibe callbacks de aprovisionamiento, navegación y mensajes.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/services_hub/services_hub_dialog.dart';

/// Botón de acceso al Hub de Servicios del Ecosistema Raft
class TopbarServicesHubButton extends StatelessWidget {
  const TopbarServicesHubButton({
    required this.isDesktop, // Layout responsivo
    required this.onCreateDatabase, // Callback creación BD
    this.onSelectTab, // Callback cambio de pestaña
    this.onMessage, // Notificador
    super.key,
  });

  final bool isDesktop;
  final VoidCallback onCreateDatabase;
  final ValueChanged<int>? onSelectTab;
  final void Function(String message, {bool success})? onMessage;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? AppColors.nightPrimary : AppColors.dayPrimary;
    final fgColor = isDark ? AppColors.nightBackground : Colors.white;

    return FilledButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => ServicesHubDialog(
            onCreateDatabase: onCreateDatabase,
            onSelectTab: onSelectTab,
            onMessage: onMessage,
          ),
        );
      },
      icon: const Icon(Icons.grid_view_rounded, size: 18),
      label: Text(isDesktop ? 'Ecosistema Raft' : 'Servicios'),
      style: FilledButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 18 : 12,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
