import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart'; // Domain

/// ¿Qué hace?: Renderiza las insignias de estado (Direct TCP, SSL Activo) y los botones de acción para una fila DNS.
/// ¿De dónde recibe datos?: Ingesta DnsRecord, callbacks de acción y responde al tema activo.
/// ¿Hacia dónde va / Cómo se conecta?: Se utiliza en DnsRowItem para componer el layout desktop y móvil.

/// Sub-widget: Badge Direct TCP (proxied: false)
class DirectTcpBadge extends StatelessWidget {
  const DirectTcpBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final warningColor = AppColors.warning;

    return Tooltip(
      message: 'proxied: false (Conexión TCP directa requerida para BD)',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: warningColor.withValues(alpha: isDark ? 0.18 : 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: warningColor.withValues(alpha: isDark ? 0.40 : 0.60)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 12,
              color: warningColor,
            ),
            const SizedBox(width: 4),
            Text(
              'Direct TCP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sub-widget: Badge SSL Universal Activo
class SslBadge extends StatelessWidget {
  const SslBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = AppColors.success;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: successColor.withValues(alpha: isDark ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: successColor.withValues(alpha: isDark ? 0.40 : 0.60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 12,
            color: successColor,
          ),
          const SizedBox(width: 4),
          Text(
            'SSL Activo',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: successColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Sub-widget: Botones de Acción (Copiar FQDN, Editar y Eliminar)
class DnsRowActions extends StatelessWidget {
  const DnsRowActions({
    required this.item,
    required this.onEdit,
    required this.onDelete,
    required this.onMessage,
    super.key,
  });

  final DnsRecord item;
  final ValueChanged<DnsRecord> onEdit;
  final ValueChanged<DnsRecord> onDelete;
  final void Function(String message, {bool success}) onMessage;

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
