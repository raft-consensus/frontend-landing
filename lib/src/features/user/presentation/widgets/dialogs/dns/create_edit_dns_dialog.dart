import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart'; // Domain

/// ¿Qué hace?: Formulario modal estandarizado para crear o editar registros DNS tipo A con soporte Día/Noche.
/// ¿De dónde trae datos?: Consume AppColors y entidades DnsRecord.
/// ¿Hacia dónde va / Cómo se conecta?: Invocado en DnsSslPage para aprovisionar o modificar subdominios.
class CreateEditDnsDialog extends StatefulWidget {
  const CreateEditDnsDialog({this.initialRecord, super.key});

  final DnsRecord? initialRecord;

  @override
  State<CreateEditDnsDialog> createState() => _CreateEditDnsDialogState();
}

class _CreateEditDnsDialogState extends State<CreateEditDnsDialog> {
  final _subdomainController = TextEditingController();
  final _ipController = TextEditingController();
  final _commentController = TextEditingController();
  String? _errorMessage;

  bool get _isEditing => widget.initialRecord != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final rec = widget.initialRecord!;
      _subdomainController.text = rec.name;
      _ipController.text = rec.content;
      _commentController.text = rec.comment ?? '';
    }
  }

  @override
  void dispose() {
    _subdomainController.dispose();
    _ipController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submit() {
    final sub = _subdomainController.text.trim().toLowerCase();
    final ip = _ipController.text.trim();
    final comm = _commentController.text.trim();
    if (sub.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa el nombre del subdominio.';
      });
      return;
    }
    if (ip.isEmpty) {
      setState(() {
        _errorMessage = 'Ingresa la dirección IP IPv4 de destino.';
      });
      return;
    }
    Navigator.pop(context, {
      'subdomain': sub,
      'targetIp': ip,
      'comment': comm.isEmpty ? null : comm,
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, titleColor, subtitleColor),
              const SizedBox(height: 20),
              _buildSubdomainField(context),
              const SizedBox(height: 14),
              _buildIpField(context),
              const SizedBox(height: 14),
              _buildCommentField(context),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                _buildErrorMessage(),
              ],
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color titleColor, Color subtitleColor) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Icon(
                _isEditing ? Icons.edit_rounded : Icons.add_link_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _isEditing ? 'Editar Registro DNS' : 'Nuevo Subdominio DNS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: titleColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Configura tu subdominio A bajo el dominio principal coderhivex.com',
          style: TextStyle(fontSize: 12, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildSubdomainField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _subdomainController,
      decoration: InputDecoration(
        labelText: 'Subdominio',
        hintText: 'ej. midb',
        suffixText: 'raft.coderhivex.com',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildIpField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _ipController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Direccion IPv4 Destino',
        hintText: 'ej. 198.51.100.1',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        isDense: true,
      ),
    );
  }

  Widget _buildCommentField(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _commentController,
      maxLength: 90,
      maxLines: 3,
      minLines: 2,
      decoration: InputDecoration(
        labelText: 'Comentario / Nota (Opcional)',
        hintText:
            'ej. Servidor de Producción PostgreSQL o detalles del uso de este subdominio',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(
      _errorMessage!,
      style: const TextStyle(color: AppColors.error, fontSize: 12),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.dividerColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(_isEditing ? 'Guardar Cambios' : 'Aprovisionar DNS'),
        ),
      ],
    );
  }
}
