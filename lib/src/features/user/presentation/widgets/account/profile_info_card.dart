import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_profile_provider.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_date_helper.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_form.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/account/profile/profile_header.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/common/dashboard_card.dart';

/// Orquestador modular ultracompacto de la tarjeta de perfil de usuario.
/// 
/// ¿Qué hace?: Ensambla ProfileHeader y ProfileForm administrando la carga inicial y delegando la fecha a ProfileDateHelper.
/// ¿De dónde recibe datos?: Del userProfileProvider.
/// ¿Hacia dónde se conecta?: Renderizado en el panel principal de AccountPage.
class ProfileInfoCard extends ConsumerStatefulWidget {
  const ProfileInfoCard({
    required this.onMessage,
    super.key,
  });

  final void Function(String message, {bool success}) onMessage;

  @override
  ConsumerState<ProfileInfoCard> createState() => _ProfileInfoCardState();
}

class _ProfileInfoCardState extends ConsumerState<ProfileInfoCard> {
  final _nameController = TextEditingController();
  final _orgController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _countryController = TextEditingController();
  String _selectedGender = 'Masculino';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(userProfileProvider.notifier).loadProfile();
      final profile = ref.read(userProfileProvider);
      _nameController.text = profile.name;
      _orgController.text = profile.organization;
      _phoneController.text = profile.phone;
      _countryController.text = profile.country;
      _birthDateController.text = ProfileDateHelper.toDisplayDate(profile.birthDate);
      setState(() {
        _selectedGender = profile.gender.isNotEmpty ? profile.gender : 'Masculino';
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orgController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      widget.onMessage('El nombre no puede estar vacío.', success: false);
      return;
    }

    final success = await ref.read(userProfileProvider.notifier).updateProfile(
      name: name,
      organization: _orgController.text.trim(),
      phone: _phoneController.text.trim(),
      gender: _selectedGender,
      birthDate: ProfileDateHelper.toIsoDate(_birthDateController.text),
      country: _countryController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      widget.onMessage('Perfil actualizado correctamente.', success: true);
    } else {
      final error = ref.read(userProfileProvider).errorMessage ?? 'Error al actualizar el perfil.';
      widget.onMessage(error, success: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileHeader(role: profile.role),
          const SizedBox(height: 20),
          if (profile.isLoading && profile.name.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            ProfileForm(
              nameController: _nameController,
              orgController: _orgController,
              phoneController: _phoneController,
              selectedGender: _selectedGender,
              onGenderChanged: (val) {
                if (val != null) setState(() => _selectedGender = val);
              },
              birthDateController: _birthDateController,
              onSelectBirthDate: () async {
                final date = await ProfileDateHelper.pickDate(context, _birthDateController.text);
                if (date != null) setState(() => _birthDateController.text = date);
              },
              countryController: _countryController,
              email: profile.email,
              isLoading: profile.isLoading,
              onSave: _handleSave,
            ),
        ],
      ),
    );
  }
}
