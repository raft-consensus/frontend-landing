import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/field_label.dart';

/// Sub-widget modular para datos personales (Género, Fecha de Nacimiento con DatePicker y País).
/// 
/// ¿Qué hace?: Renderiza el desplegable de Género, el campo interactivo de Fecha de Nacimiento y País.
/// ¿De dónde recibe datos?: Género seleccionado, controlador de fecha, callback del DatePicker, controlador de país e isLoading.
/// ¿Hacia dónde se conecta?: Ensamblado dentro de ProfileForm.
class ProfilePersonalFields extends StatelessWidget {
  const ProfilePersonalFields({
    required this.selectedGender,
    required this.onGenderChanged,
    required this.birthDateController,
    required this.onSelectBirthDate,
    required this.countryController,
    required this.isLoading,
    required this.isWide,
    super.key,
  });

  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final TextEditingController birthDateController;
  final VoidCallback onSelectBirthDate;
  final TextEditingController countryController;
  final bool isLoading;
  final bool isWide;

  static const List<String> genderOptions = [
    'Masculino',
    'Femenino',
    'LGBTQ+',
    'Otro',
  ];

  @override
  Widget build(BuildContext context) {
    final validGender = genderOptions.contains(selectedGender) ? selectedGender : 'Otro';

    final genderField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Género'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: validGender,
          onChanged: isLoading ? null : onGenderChanged,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.wc_outlined),
          ),
          items: genderOptions.map((gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
        ),
      ],
    );

    final birthDateField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('Fecha de nacimiento'),
        const SizedBox(height: 6),
        TextFormField(
          controller: birthDateController,
          readOnly: true,
          onTap: isLoading ? null : onSelectBirthDate,
          decoration: InputDecoration(
            hintText: 'AAAA-MM-DD',
            prefixIcon: const Icon(Icons.calendar_month_outlined),
            suffixIcon: IconButton(
              icon: const Icon(Icons.edit_calendar_rounded, size: 18),
              onPressed: isLoading ? null : onSelectBirthDate,
            ),
          ),
        ),
      ],
    );

    final countryField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('País'),
        const SizedBox(height: 6),
        TextFormField(
          controller: countryController,
          enabled: !isLoading,
          decoration: const InputDecoration(
            hintText: 'Ej: Colombia',
            prefixIcon: Icon(Icons.public_outlined),
          ),
        ),
      ],
    );

    if (isWide) {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: genderField),
              const SizedBox(width: 14),
              Expanded(child: birthDateField),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: countryField),
              const SizedBox(width: 14),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        genderField,
        const SizedBox(height: 14),
        birthDateField,
        const SizedBox(height: 14),
        countryField,
      ],
    );
  }
}
