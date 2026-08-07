import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/dns_record.dart';

/// ¿Qué hace?: Formulario modal estandarizado para crear o editar registros DNS tipo A.
/// ¿De dónde trae?: Consume AppColors de core/theme y entidades DnsRecord / DatabaseInstance.
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

  /// Valida el formulario y retorna los datos al llamador
  void _submit() {
    final sub = _subdomainController.text.trim().toLowerCase();
    final ip = _ipController.text.trim();
    final comm = _commentController.text.trim(); // <-- Leer comentario aquí
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSubdomainField(),
              const SizedBox(height: 14),
              _buildIpField(),
              const SizedBox(height: 14),
              _buildCommentField(),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                _buildErrorMessage(),
              ],
              const SizedBox(height: 24),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Encabezado con icono, titulo y subtitulo descriptivo
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.blue.withValues(alpha: 0.1),
              child: Icon(
                _isEditing ? Icons.edit_rounded : Icons.add_link_rounded,
                color: AppColors.blue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _isEditing ? 'Editar Registro DNS' : 'Nuevo Subdominio DNS',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Configura tu subdominio A bajo el dominio principal coderhivex.com',
          style: TextStyle(fontSize: 12, color: AppColors.muted),
        ),
      ],
    );
  }

  /// Campo de texto para ingresar el nombre del subdominio
  Widget _buildSubdomainField() {
    return TextField(
      controller: _subdomainController,
      decoration: const InputDecoration(
        labelText: 'Subdominio',
        hintText: 'ej. midb',
        suffixText: '.coderhivex.com',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  /// Campo de texto para ingresar la IP destino de la base de datos
  Widget _buildIpField() {
    return TextField(
      controller: _ipController,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Direccion IPv4 Destino',
        hintText: 'ej. 198.51.100.1',
        border: OutlineInputBorder(),
        isDense: true,
      ),
    );
  }

  /// Campo de área de texto multilínea para ingresar una nota u observación opcional (Máx. 90 caracteres)
  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      maxLength: 90,
      maxLines: 3,
      minLines: 2,
      decoration: const InputDecoration(
        labelText: 'Comentario / Nota (Opcional)',
        hintText:
            'ej. Servidor de Producción PostgreSQL o detalles del uso de este subdominio',
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      ),
    );
  }

  /// Banner de mensaje de error de validacion
  Widget _buildErrorMessage() {
    return Text(
      _errorMessage!,
      style: const TextStyle(color: AppColors.red, fontSize: 12),
    );
  }

  /// Botones de guardar y cancelar en la parte inferior del modal
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, null);
          },
          child: const Text('Cancelar'),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: _submit,
          style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
          child: Text(_isEditing ? 'Guardar Cambios' : 'Aprovisionar DNS'),
        ),
      ],
    );
  }
}
