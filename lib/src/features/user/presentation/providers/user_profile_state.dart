/// Estado inmutable para la gestión del perfil de usuario acorde al contrato de la API.
/// 
/// ¿Qué hace?: Almacena id, nombre, correo, organización, teléfono, género, fecha de nacimiento, país y rol.
/// ¿De dónde recibe datos?: Modificado mediante UserProfileNotifier.copyWith.
/// ¿Hacia dónde se conecta?: Consumido por ProfileInfoCard y ProfileForm.
class UserProfileState {
  const UserProfileState({
    this.id = 0,
    this.name = '',
    this.email = '',
    this.organization = '',
    this.phone = '',
    this.gender = '',
    this.birthDate = '',
    this.country = '',
    this.role = 'User',
    this.isLoading = false,
    this.errorMessage,
  });

  final int id;
  final String name;
  final String email;
  final String organization;
  final String phone;
  final String gender;
  final String birthDate;
  final String country;
  final String role;
  final bool isLoading;
  final String? errorMessage;

  UserProfileState copyWith({
    int? id,
    String? name,
    String? email,
    String? organization,
    String? phone,
    String? gender,
    String? birthDate,
    String? country,
    String? role,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserProfileState(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      organization: organization ?? this.organization,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      country: country ?? this.country,
      role: role ?? this.role,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
