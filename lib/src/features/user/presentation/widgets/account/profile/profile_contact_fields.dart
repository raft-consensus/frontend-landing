import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart';

/// Sub-widget modular para campos de contacto (Organización y Teléfono).
/// 
/// ¿Qué hace?: Renderiza las entradas de Organización / Universidad y Teléfono de contacto.
/// ¿De dónde recibe datos?: Controladores de texto, estado de carga y flag responsivo isWide.
/// ¿Hacia dónde se conecta?: Ensamblado dentro de ProfileForm.
class ProfileContactFields extends StatelessWidget {
  const ProfileContactFields({
    required this.orgController,
    required this.phoneController,
    required this.isLoading,
    required this.isWide,
    super.key,
  });

  final TextEditingController orgController;
  final TextEditingController phoneController;
  final bool isLoading;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final orgField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Organización / Universidad'),
        const SizedBox(height: 6),
        TextFormField(
          controller: orgController,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'Tu institución o empresa',
            prefixIcon: Icon(Icons.school_outlined),
          ),
        ),
      ],
    );

    final phoneField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Teléfono de contacto'),
        const SizedBox(height: 6),
        TextFormField(
          controller: phoneController,
          enabled: !isLoading,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            hintText: '+57 300 1234567',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: orgField),
          const SizedBox(width: 14),
          Expanded(child: phoneField),
        ],
      );
    }

    return Column(
      children: [
        orgField,
        const SizedBox(height: 14),
        phoneField,
      ],
    );
  }
}
