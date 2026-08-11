import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/recover_password_actions.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/recover_password_form.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/login/recover_password_header.dart';

/// Diálogo modal orquestador para la recuperación de contraseña.
/// 
/// ¿Qué hace?: Ensambla los componentes atómicos (Header, Form, Actions) en un modal Dialog.
/// ¿De dónde recibe datos?: Recibe la función `onSubmit` desde la pantalla principal.
/// ¿Hacia dónde se conecta?: Envía el correo validado a la pantalla invocadora.
class RecoverPasswordDialog extends StatefulWidget {
  const RecoverPasswordDialog({
    required this.onSubmit,
    super.key,
  });

  /// Callback para procesar la recuperación de contraseña con el email ingresado
  final Future<void> Function(String email) onSubmit;

  @override
  State<RecoverPasswordDialog> createState() => _RecoverPasswordDialogState();
}

class _RecoverPasswordDialogState extends State<RecoverPasswordDialog> {
  /// Clave del formulario para validación
  final _formKey = GlobalKey<FormState>();

  /// Controlador del campo de texto de correo
  final _emailController = TextEditingController();

  /// Estado de procesamiento asíncrono
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Ejecuta el proceso de envío tras validar el formulario
  Future<void> _handleSend() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await widget.onSubmit(_emailController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 440),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado modularizado
              RecoverPasswordHeader(
                isLoading: _isLoading,
                onClose: () => Navigator.of(context).pop(),
              ),
              const SizedBox(height: 24),
              // Campo de entrada modularizado
              RecoverPasswordForm(
                emailController: _emailController,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 28),
              // Acciones modularizadas
              RecoverPasswordActions(
                isLoading: _isLoading,
                onCancel: () => Navigator.of(context).pop(),
                onSend: _handleSend,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
