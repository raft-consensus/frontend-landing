// ==========================================
// Qué hace: Tabla contenedora que itera la lista de API Keys de IA y gestiona el estado vacío.
// Dónde se conecta: Se incluye en AiServicesPage.
// De dónde trae datos: Ingesta la lista de AiKey y delega acciones a AiKeyRowItem.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/ai_key.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/ai/ai_key_row_item.dart'; // AI Widgets

/// Tabla contenedora de la lista de API Keys
class AiKeysTable extends StatelessWidget {
  const AiKeysTable({
    required this.keys,
    required this.onRotate,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final List<AiKey> keys;
  final ValueChanged<AiKey> onRotate;
  final ValueChanged<AiKey> onDelete;
  final void Function(String message, {bool success}) onMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (keys.isEmpty) return _buildEmptyState(context, isDark);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: theme.dividerColor),
        itemBuilder: (context, index) {
          return AiKeyRowItem(
            item: keys[index],
            onRotate: onRotate,
            onDelete: onDelete,
            onMessage: onMessage,
          );
        },
      ),
    );
  }

  /// Estado vacío si el usuario no tiene ninguna clave creada
  Widget _buildEmptyState(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(Icons.vpn_key_off_outlined, size: 48, color: subtitleColor),
          const SizedBox(height: 12),
          Text('No tienes API Keys de IA generadas', style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
          const SizedBox(height: 4),
          Text('Presiona "+ Crear API Key" para generar tu primera clave de acceso', style: TextStyle(color: subtitleColor, fontSize: 12)),
        ],
      ),
    );
  }
}
