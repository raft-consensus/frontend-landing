import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/auth/presentation/widgets/common/field_label.dart';

/// Formulario para ingresar el correo electrónico en la recuperación de contraseña.
/// 
/// ¿Qué hace?: Muestra el campo de texto con su etiqueta y realiza la validación de formato de email.
/// ¿De dónde recibe datos?: Del controlador de texto y el estado de carga pasados por el modal padre.
/// ¿Hacia dónde se conecta?: Al flujo de validación del FormState del modal.
class RecoverPasswordForm extends StatelessWidget {
  const RecoverPasswordForm({
    required this.emailController,
    required this.isLoading,
    super.key,
  });

  /// Controlador para gestionar el texto ingresado en el campo de correo
  final TextEditingController emailController;

  /// Deshabilita la edición mientras se realiza la llamada a la API
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Correo electrónico'),
        const SizedBox(height: 8),
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'nombre@correo.com',
            prefixIcon: Icon(Icons.mail_outline_rounded),
          ),
          validator: (value) {
            final email = value?.trim() ?? '';
            if (email.isEmpty) {
              return 'Ingresa tu correo.';
            }
            if (!email.contains('@') || !email.contains('.')) {
              return 'Ingresa un correo válido.';
            }
            return null;
          },
        ),
      ],
    );
  }
}
