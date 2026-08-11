import 'package:flutter/material.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_basic_fields.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_contact_fields.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_personal_fields.dart';

/// Formulario modularizado para la edición de perfil.
/// 
/// ¿Qué hace?: Ensambla los tres bloques de campos incluyendo la selección de fecha de nacimiento.
/// ¿De dónde recibe datos?: Controladores de texto, selección de fecha/género, estado de carga y callback onSave.
/// ¿Hacia dónde se conecta?: Orquestado por ProfileInfoCard.
class ProfileForm extends StatelessWidget {
  const ProfileForm({
    required this.nameController,
    required this.orgController,
    required this.phoneController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.birthDateController,
    required this.onSelectBirthDate,
    required this.countryController,
    required this.email,
    required this.isLoading,
    required this.onSave,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController orgController;
  final TextEditingController phoneController;
  final String selectedGender;
  final ValueChanged<String?> onGenderChanged;
  final TextEditingController birthDateController;
  final VoidCallback onSelectBirthDate;
  final TextEditingController countryController;
  final String email;
  final bool isLoading;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.of(context).size.width >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bloque 1: Nombre completo y Correo (Visible de solo lectura)
        ProfileBasicFields(
          nameController: nameController,
          email: email,
          isLoading: isLoading,
          isWide: isWide,
        ),
        const SizedBox(height: 14),

        // Bloque 2: Organización y Teléfono
        ProfileContactFields(
          orgController: orgController,
          phoneController: phoneController,
          isLoading: isLoading,
          isWide: isWide,
        ),
        const SizedBox(height: 14),

        // Bloque 3: Género, Fecha de Nacimiento y País
        ProfilePersonalFields(
          selectedGender: selectedGender,
          onGenderChanged: onGenderChanged,
          birthDateController: birthDateController,
          onSelectBirthDate: onSelectBirthDate,
          countryController: countryController,
          isLoading: isLoading,
          isWide: isWide,
        ),
        const SizedBox(height: 20),

        // Botón de guardado
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: isLoading ? null : onSave,
            icon: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colorScheme.onPrimary,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 16),
            label: Text(isLoading ? 'Guardando...' : 'Guardar cambios'),
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}
