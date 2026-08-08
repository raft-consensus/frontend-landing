import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core
import 'package:frontend_landing/src/features/user/domain/entities/database_instance.dart'; // Domain
import 'package:frontend_landing/src/features/user/presentation/providers/user_databases_provider.dart'; // Providers
import 'package:frontend_landing/src/features/user/presentation/widgets/common/info_banner.dart'; // Common
import 'package:frontend_landing/src/features/user/presentation/widgets/dialogs/databases/credential_item.dart'; // Dialogs

/// Modal principal para consultar y copiar credenciales de conexión con soporte Día/Noche
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

  String get _displayPassword => _realPassword ?? '••••••••••••••';

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
    final result = await ref
        .read(userDatabasesProvider.notifier)
        .revealPassword(instanceIdInt);
    if (!mounted) return;
    if (result.password != null && result.password!.isNotEmpty) {
      setState(() {
        _realPassword = result.password;
        _showPassword = true;
        _loadingPassword = false;
      });
    } else {
      setState(() => _loadingPassword = false);
      widget.onMessage(
        result.error ?? 'No se pudo obtener la contraseña del servidor.',
        success: false,
      );
    }
  }

  void _copy(String label, String value) {
    Clipboard.setData(ClipboardData(text: value));
    widget.onMessage('$label copiado.', success: true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final instance = widget.instance;
    final connectionUri =
        '${instance.engine.toLowerCase()}://${instance.username}:${_realPassword ?? 'TU_CONTRASEÑA'}@${instance.host}:${instance.port}/${instance.database}';

    final titleColor = isDark ? AppColors.nightTextPrimary : AppColors.dayTextPrimary;
    final subtitleColor = isDark ? AppColors.nightTextSecondary : AppColors.dayTextSecondary;

    return Dialog(
      backgroundColor: theme.cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Cabecera del modal
              _buildHeader(context, instance.name, titleColor, subtitleColor),
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

              // 3. Fila de Contraseña con visibilidad
              _buildPasswordItem(subtitleColor),
              const SizedBox(height: 14),

              // 4. Banner de advertencia
              InfoBanner(
                message:
                    'No compartas estas credenciales ni las publiques en repositorios.',
                icon: Icons.warning_amber_rounded,
                iconColor: AppColors.warning,
              ),
              const SizedBox(height: 20),

              // 5. Cadena de conexión URI estilo consola
              _buildUriSection(context, connectionUri, titleColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title, Color titleColor, Color subtitleColor) {
    final theme = Theme.of(context);

    return Row(
      children: [
        CircleAvatar(
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
          child: Icon(Icons.key_rounded, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Credenciales de conexión',
                style: TextStyle(
                  color: titleColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: subtitleColor, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_rounded, color: subtitleColor),
        ),
      ],
    );
  }

  Widget _buildPasswordItem(Color labelColor) {
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
                color: labelColor,
              ),
            ),
          IconButton(
            tooltip: 'Copiar',
            onPressed: _realPassword != null
                ? () => _copy('Contraseña', _realPassword!)
                : _togglePasswordVisibility,
            icon: Icon(Icons.copy_rounded, color: labelColor),
          ),
        ],
      ),
    );
  }

  Widget _buildUriSection(BuildContext context, String uri, Color titleColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cadena de conexión (URI):',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: titleColor,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF09131F) : const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: SelectableText(
                  uri,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    color: Color(0xFF5AB8FF),
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
