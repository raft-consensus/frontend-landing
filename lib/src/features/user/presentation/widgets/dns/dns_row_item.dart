import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/dns/dns_row_actions.dart'; // Widgets

/// ¿Qué hace?: Componente de fila individual para visualizar un registro DNS con resaltado interativo hover.
/// ¿De dónde trae datos?: Ingesta DnsRecord, callbacks de acción y delega botones a DnsRowActions.
/// ¿Hacia dónde va / Cómo se conecta?: Se importa dentro de DnsTable para renderizar cada elemento.
class DnsRowItem extends StatefulWidget {
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
  State<DnsRowItem> createState() => _DnsRowItemState();
}

class _DnsRowItemState extends State<DnsRowItem> {
  // Estado local para animación hover en la fila
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Fondo interactivo: Si hay hover se ilumina suavemente con el tono primario
    final hoverBg = theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04);
    final normalBg = Colors.transparent;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: _isHovered ? hoverBg : normalBg,
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 650;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: isSmall
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),
            );
          },
        ),
      ),
    );
  }

  /// Layout horizontal para escritorio
  Widget _buildDesktopLayout(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        // Icono circular que resplandece al hacer hover
        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: _isHovered ? 0.20 : 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.link_rounded,
            color: theme.colorScheme.primary,
            size: 18,
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
                    widget.item.fqdn,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      color: isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _TypeBadge(type: widget.item.type),
                ],
              ),
              const SizedBox(height: 4),
              _SubtitleText(content: widget.item.content, comment: widget.item.comment),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const DirectTcpBadge(),
        const SizedBox(width: 8),
        const SslBadge(),
        const SizedBox(width: 12),
        DnsRowActions(
          item: widget.item,
          onEdit: widget.onEdit,
          onDelete: widget.onDelete,
          onMessage: widget.onMessage,
        ),
      ],
    );
  }

  /// Layout vertical para dispositivos móviles
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Icon(
                Icons.link_rounded,
                color: theme.colorScheme.primary,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: 6,
                children: [
                  SelectableText(
                    widget.item.fqdn,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                      color: isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary,
                    ),
                  ),
                  _TypeBadge(type: widget.item.type),
                ],
              ),
            ),
            DnsRowActions(
              item: widget.item,
              onEdit: widget.onEdit,
              onDelete: widget.onDelete,
              onMessage: widget.onMessage,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _SubtitleText(content: widget.item.content, comment: widget.item.comment),
        const SizedBox(height: 10),
        const Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [DirectTcpBadge(), SslBadge()],
        ),
      ],
    );
  }
}

/// Sub-widget privado: Badge pequeñito del tipo de registro (ej. A)
class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.dividerColor.withValues(alpha: isDark ? 0.30 : 0.50),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary,
        ),
      ),
    );
  }
}

/// Sub-widget privado: Texto secundario de IP y Comentario
class _SubtitleText extends StatelessWidget {
  const _SubtitleText({required this.content, this.comment});

  final String content;
  final String? comment;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Text(
      'IP Destino: $content${comment != null && comment!.isNotEmpty ? "  •  Nota: $comment" : ""}',
      style: TextStyle(fontSize: 12, color: color),
    );
  }
}
