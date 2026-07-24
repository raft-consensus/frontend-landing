import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/credential_item.dart'; // Dialogs

/// ¿Qué hace?: Modal principal para consultar y copiar credenciales seguras de conexión.
/// ¿De dónde trae?: Trae AppColors (core), DatabaseInstance (domain), InfoBanner (common) y CredentialItem (dialogs).
/// ¿Hacia dónde va / Cómo se conecta?: Se despliega desde DatabaseManagementCard con showDialog().
class CredentialsDialog extends StatefulWidget {
  const CredentialsDialog({
    required this.instance,
    required this.onMessage,
    super.key,
  });

  final DatabaseInstance instance;
  final void Function(String, {bool success}) onMessage;

  @override
  State<CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends State<CredentialsDialog> {
  bool _showPassword = false;

  String get _password => 'Rft_9xK2mQ7pL4';

  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    widget.onMessage('$label copiado.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final instance = widget.instance;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(27),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado del modal
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFE3F0FC),
                    child: Icon(Icons.key_rounded, color: AppColors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Credenciales de conexión', style: TextStyle(color: AppColors.text, fontSize: 19, fontWeight: FontWeight.w900)),
                        Text(instance.name, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Lista de credenciales con el sub-widget extraído CredentialItem
              CredentialItem(label: 'Host', value: instance.host, onCopy: () => _copy('Host', instance.host)),
              CredentialItem(label: 'Puerto', value: '${instance.port}', onCopy: () => _copy('Puerto', '${instance.port}')),
              CredentialItem(label: 'Base de datos', value: instance.database, onCopy: () => _copy('Base de datos', instance.database)),
              CredentialItem(label: 'Usuario', value: instance.username, onCopy: () => _copy('Usuario', instance.username)),

              // Credencial de Contraseña con control de visibilidad
              CredentialItem(
                label: 'Contraseña',
                value: _showPassword ? _password : '••••••••••••••',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                      icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    ),
                    IconButton(
                      tooltip: 'Copiar',
                      onPressed: () => _copy('Contraseña', _password),
                      icon: const Icon(Icons.copy_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Banner de advertencia con InfoBanner (common)
              const InfoBanner(
                message: 'No compartas estas credenciales ni las publiques en repositorios de código.',
                icon: Icons.warning_amber_rounded,
                backgroundColor: Color(0xFFFFF8E9),
                borderColor: Color(0xFFFFE5AF),
                iconColor: Color(0xFFD98A00),
                textColor: Color(0xFF76561D),
              ),
              const SizedBox(height: 22),

              // Botón de copia de cadena completa
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {
                    final uri = '${instance.engine.toLowerCase()}://${instance.username}:$_password@${instance.host}:${instance.port}/${instance.database}';
                    _copy('Cadena de conexión', uri);
                  },
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Copiar cadena de conexión'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
