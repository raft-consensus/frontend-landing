import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart';

/// Sub-widget modular para los campos básicos de perfil (Nombre y Correo).
/// 
/// ¿Qué hace?: Renderiza el Nombre completo (editable) y Correo (totalmente visible, pero de solo lectura).
/// ¿De dónde recibe datos?: Controladores de texto, email, estado de carga y flag responsivo isWide.
/// ¿Hacia dónde se conecta?: Ensamblado dentro de ProfileForm.
class ProfileBasicFields extends StatelessWidget {
  const ProfileBasicFields({
    required this.nameController,
    required this.email,
    required this.isLoading,
    required this.isWide,
    super.key,
  });

  final TextEditingController nameController;
  final String email;
  final bool isLoading;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final nameField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Nombre completo'),
        const SizedBox(height: 6),
        TextFormField(
          controller: nameController,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'Tu nombre completo',
            prefixIcon: Icon(Icons.person_outline_rounded),
          ),
        ),
      ],
    );

    final emailField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Correo electrónico (Solo lectura)'),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: email,
          readOnly: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            suffixIcon: Icon(Icons.lock_rounded, size: 18),
          ),
        ),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: nameField),
          const SizedBox(width: 14),
          Expanded(child: emailField),
        ],
      );
    }

    return Column(
      children: [
        nameField,
        const SizedBox(height: 14),
        emailField,
      ],
    );
  }
}
