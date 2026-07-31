// ==========================================
// Archivo: lib/src/features/user/presentation/widgets/dialogs/credentials_dialog.dart
// Qué hace: Modal modular para consultar y copiar credenciales de conexión reales de la API.
// Dónde se conecta: Desplegado desde DatabaseManagementCard con showDialog().
// De dónde recibe datos: Consume userDatabasesProvider para consultar la contraseña real de la API.
// ==========================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/credential_item.dart';

/// Modal principal para consultar y copiar credenciales de conexión
class CredentialsDialog extends ConsumerStatefulWidget {
  const CredentialsDialog({
    required this.instance,
    required this.onMessage,
    super.key,
  });

  final DatabaseInstance instance;
  final void Function(String, {bool success}) onMessage;

  @override
  ConsumerState<CredentialsDialog> createState() => _CredentialsDialogState();
}

class _CredentialsDialogState extends ConsumerState<CredentialsDialog> {
  bool _showPassword = false;
  bool _loadingPassword = false;
  String? _realPassword;

  /// Retorna la contraseña activa o la máscara de ocultación
  String get _displayPassword => _realPassword ?? '••••••••••••••';

  // ¿Qué hace?: Solcita la contraseña a la API y notifica al usuario si existe algún error de límite o red.
  /// Solicita la contraseña a la API únicamente cuando el usuario presiona "Mostrar"
  Future<void> _togglePasswordVisibility() async {
    if (_showPassword) {
      setState(() => _showPassword = false);
      return;
    }
    if (_realPassword != null) {
      setState(() => _showPassword = true);
      return;
    }
    setState(() => _loadingPassword = true);
    final instanceIdInt = int.tryParse(widget.instance.id) ?? 0;
    // Llama al notifier de Riverpod y desempaqueta la respuesta del servidor
    final result = await ref
        .read(userDatabasesProvider.notifier)
        .revealPassword(instanceIdInt);
    if (!mounted) return;
    if (result.password != null && result.password!.isNotEmpty) {
      // Si la API devolvió la contraseña con éxito
      setState(() {
        _realPassword = result.password;
        _showPassword = true;
        _loadingPassword = false;
      });
    } else {
      // Si ocurrió una falla (ej: Rate limit de 5 peticiones por minuto o fallo de red)
      setState(() => _loadingPassword = false);
      widget.onMessage(
        result.error ?? 'No se pudo obtener la contraseña del servidor.',
        success: false,
      );
    }
  }

  /// Copia un texto al portapapeles y notifica al usuario
  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    widget.onMessage('$label copiado.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final instance = widget.instance;
    final connectionUri =
        '${instance.engine.toLowerCase()}://${instance.username}:${_realPassword ?? 'TU_CONTRASEÑA'}@${instance.host}:${instance.port}/${instance.database}';

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera del modal
              _buildHeader(instance.name),
              const SizedBox(height: 20),

              // 2. Lista de credenciales de conexión
              CredentialItem(
                label: 'Host',
                value: instance.host,
                onCopy: () => _copy('Host', instance.host),
              ),
              CredentialItem(
                label: 'Puerto',
                value: '${instance.port}',
                onCopy: () => _copy('Puerto', '${instance.port}'),
              ),
              CredentialItem(
                label: 'Base de datos',
                value: instance.database,
                onCopy: () => _copy('Base de datos', instance.database),
              ),
              CredentialItem(
                label: 'Usuario',
                value: instance.username,
                onCopy: () => _copy('Usuario', instance.username),
              ),

              // 3. Fila de la Contraseña con control de visibilidad
              _buildPasswordItem(),
              const SizedBox(height: 14),

              // 4. Banner de advertencia de seguridad
              const InfoBanner(
                message:
                    'No compartas estas credenciales ni las publiques en repositorios.',
                icon: Icons.warning_amber_rounded,
                backgroundColor: Color(0xFFFFF8E9),
                borderColor: Color(0xFFFFE5AF),
                iconColor: Color(0xFFD98A00),
                textColor: Color(0xFF76561D),
              ),
              const SizedBox(height: 20),

              // 5. Cadena de conexión URI formateada
              _buildUriSection(connectionUri),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el encabezado del modal con icono y botón de cierre
  Widget _buildHeader(String title) {
    return Row(
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
              const Text(
                'Credenciales de conexión',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }

  /// Construye el ítem de contraseña con su botón de visibilidad y copia
  Widget _buildPasswordItem() {
    return CredentialItem(
      label: 'Contraseña',
      value: _showPassword ? _displayPassword : '••••••••••••••',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_loadingPassword)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            IconButton(
              tooltip: _showPassword ? 'Ocultar' : 'Mostrar',
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _showPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
              ),
            ),
          IconButton(
            tooltip: 'Copiar',
            onPressed: _realPassword != null
                ? () => _copy('Contraseña', _realPassword!)
                : _togglePasswordVisibility,
            icon: const Icon(Icons.copy_rounded),
          ),
        ],
      ),
    );
  }

  /// Construye la sección de la URI de conexión tipo terminal
  Widget _buildUriSection(String uri) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cadena de conexión (URI):',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  uri,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF38BDF8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Copiar URI',
                onPressed: () => _copy('Cadena de conexión', uri),
                icon: const Icon(
                  Icons.copy_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
