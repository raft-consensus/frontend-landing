import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';

/// ¿Qué hace?: Componente de fila individual para visualizar un registro DNS con badges SSL, Direct TCP y acciones.
/// ¿De dónde trae?: Consume AppColors de core/theme y recibe una entidad DnsRecord.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de DnsTable para renderizar cada elemento de la lista.
class DnsRowItem extends StatelessWidget {
  const DnsRowItem({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 650;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: isSmall
              ? _buildMobileLayout(context)
              : _buildDesktopLayout(context),
        );
      },
    );
  }

  /// Diseño horizontal completo para pantallas de Escritorio / Tablet
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.blue.withValues(alpha: 0.1),
          child: const Icon(
            Icons.link_rounded,
            color: AppColors.blue,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SelectableText(
                    item.fqdn,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildTypeBadge(),
                ],
              ),
              const SizedBox(height: 4),
              _buildSubtitleText(),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _buildDirectTcpBadge(),
        const SizedBox(width: 8),
        _buildSslBadge(),
        const SizedBox(width: 12),
        _buildActionButtons(),
      ],
    );
  }

  /// Diseño vertical adaptativo para pantallas Móviles
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1: Icono, FQDN y Botones de Acción a la derecha
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.blue.withValues(alpha: 0.1),
              child: const Icon(
                Icons.link_rounded,
                color: AppColors.blue,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 6,
                children: [
                  SelectableText(
                    item.fqdn,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  _buildTypeBadge(),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
        const SizedBox(height: 8),
        // Fila 2: Texto de IP Destino y Comentario
        _buildSubtitleText(),
        const SizedBox(height: 10),
        // Fila 3: Badges de Direct TCP y SSL al pie
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [_buildDirectTcpBadge(), _buildSslBadge()],
        ),
      ],
    );
  }

  /// Badge pequeñito del tipo de registro (ej. A)
  Widget _buildTypeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        item.type,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Texto secundario de IP y Comentario
  Widget _buildSubtitleText() {
    return Text(
      'IP Destino: ${item.content}${item.comment != null && item.comment!.isNotEmpty ? "  •  Nota: ${item.comment}" : ""}',
      style: const TextStyle(fontSize: 12, color: AppColors.muted),
    );
  }

  /// Badge para indicar proxied: false (Direct TCP)
  Widget _buildDirectTcpBadge() {
    return Tooltip(
      message: 'proxied: false (Conexión TCP directa requerida para BD)',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.amber.shade700),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 12,
              color: Colors.amber.shade900,
            ),
            const SizedBox(width: 4),
            Text(
              'Direct TCP',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Badge indicativo de SSL Universal Activo
  Widget _buildSslBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 12,
            color: Colors.green.shade800,
          ),
          const SizedBox(width: 4),
          Text(
            'SSL Activo',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
        ],
      ),
    );
  }

  /// Botones de acción: Copiar, Editar y Eliminar
  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 18),
          tooltip: 'Copiar FQDN',
          onPressed: () {
            Clipboard.setData(ClipboardData(text: item.fqdn));
            onMessage('FQDN ${item.fqdn} copiado al portapapeles.');
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.edit_outlined,
            size: 18,
            color: AppColors.blue,
          ),
          tooltip: 'Editar Registro DNS',
          onPressed: () => onEdit(item),
        ),
        IconButton(
          icon: const Icon(
            Icons.delete_outline_rounded,
            size: 18,
            color: AppColors.red,
          ),
          tooltip: 'Eliminar Registro DNS',
          onPressed: () => onDelete(item),
        ),
      ],
    );
  }
}
