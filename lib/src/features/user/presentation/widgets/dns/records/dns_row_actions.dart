// ==========================================
// Qué hace: Fila de botones de acción para registros DNS (Copiar FQDN, Editar y Eliminar).
// Dónde se conecta: Invocado en las filas de subdominios.
// De dónde trae datos: Recibe el item DnsRecord y callbacks de acción.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';

/// Botones de acción rápida para un registro DNS
class DnsRowActions extends StatelessWidget {
  const DnsRowActions({
    required this.item, // Registro DNS asociado
    required this.onEdit, // Callback para editar
    required this.onDelete, // Callback para eliminar
    required this.onMessage, // Callback para notificaciones
    super.key,
  });

  final DnsRecord item; // Registro
  final ValueChanged<DnsRecord> onEdit; // Evento de edición
  final ValueChanged<DnsRecord> onDelete; // Evento de eliminación
  final void Function(String message, {bool success}) onMessage; // Notificador

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            Icons.copy_rounded,
            size: 18,
            color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
          ),
          tooltip: 'Copiar FQDN',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: item.fqdn));
            onMessage('FQDN ${item.fqdn} copiado al portapapeles.');
          },
        ),
        IconButton(
          icon: Icon(
            Icons.edit_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          tooltip: 'Editar Registro DNS',
          onPressed: () => onEdit(item),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: AppColors.error,
          ),
          tooltip: 'Eliminar Registro DNS',
          onPressed: () => onDelete(item),
        ),
      ],
    );
  }
}
