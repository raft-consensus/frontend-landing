import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security/security_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security/security_oauth_notice.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/security/security_password_form.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';

/// Orquestador modular de la tarjeta de seguridad de la cuenta.
/// 
/// ¿Qué hace?: Muestra el formulario de cambio de clave únicamente para usuarios registrados por email.
///              Para usuarios de OAuth (Google/GitHub), muestra exclusivamente el aviso sin campos de clave.
/// ¿De dónde recibe datos?: De authProvider (sesión activa del usuario).
/// ¿Hacia dónde se conecta?: Dispara el cambio de contraseña al backend mediante authProvider.notifier.changePassword.
class SecurityCard extends ConsumerStatefulWidget {
  const SecurityCard({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  ConsumerState<SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends ConsumerState<SecurityCard> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    final currentPassword = _currentPassController.text.trim();
    final newPassword = _newPassController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      widget.onMessage('Ingresa tu contraseña actual y la nueva.', success: false);
      return;
    }

    if (newPassword.length < 8) {
      widget.onMessage('La nueva contraseña debe tener al menos 8 caracteres.', success: false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await ref.read(authProvider.notifier).changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (!mounted) return;

      if (success) {
        _currentPassController.clear();
        _newPassController.clear();
        widget.onMessage('Contraseña actualizada con éxito.', success: true);
      } else {
        final errorMessage = ref.read(authProvider).errorMessage ?? 
            'No se pudo actualizar la contraseña.';
        widget.onMessage(errorMessage, success: false);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(authProvider).session;
    final provider = session?.provider.toLowerCase() ?? '';
    final isOAuth = provider == 'google' || provider == 'github';

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SecurityHeader(),
          const SizedBox(height: 20),
          if (isOAuth)
            SecurityOauthNotice(provider: session?.provider ?? 'OAuth')
          else
            SecurityPasswordForm(
              currentPassController: _currentPassController,
              newPassController: _newPassController,
              isLoading: _isLoading,
              onSubmit: _handleUpdatePassword,
            ),
        ],
      ),
    );
  }
}
