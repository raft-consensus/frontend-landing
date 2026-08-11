import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_landing/src/core/network/session_storage.dart';
import 'package:frontend_landing/src/features/user/data/datasources/user_profile_remote_datasource.dart';
import 'package:frontend_landing/src/features/user/presentation/providers/user_profile_state.dart';

// Exporta UserProfileState para mantener compatibilidad con las pantallas que lo importan directamente
export 'package:frontend_landing/src/features/user/presentation/providers/user_profile_state.dart';

/// Gestor de estado para consultar y actualizar el perfil del usuario logueado.
/// 
/// ¿Qué hace?: Invoca los endpoints GET /api/me/profile y PUT /api/me/profile.
/// ¿De dónde recibe datos?: De UserProfileRemoteDataSource y SessionStorage.
/// ¿Hacia dónde se conecta?: Consumido por ProfileInfoCard y ProfileForm.
class UserProfileNotifier extends StateNotifier<UserProfileState> {
  UserProfileNotifier({
    required this.remoteDataSource,
    required this.sessionStorage,
  }) : super(const UserProfileState());

  final UserProfileRemoteDataSource remoteDataSource;
  final SessionStorage sessionStorage;

  /// Carga los datos del perfil del usuario (GET /api/me/profile)
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final token = await sessionStorage.getToken();
      if (token == null || token.isEmpty) return;

      final data = await remoteDataSource.getProfile(token);
      state = state.copyWith(
        id: (data['id'] as num?)?.toInt() ?? 0,
        name: data['name'] as String? ?? '',
        email: data['email'] as String? ?? '',
        organization: data['organization'] as String? ?? '',
        phone: data['phone'] as String? ?? '',
        gender: data['gender'] as String? ?? '',
        birthDate: data['birthDate'] as String? ?? '',
        country: data['country'] as String? ?? '',
        role: data['role'] as String? ?? 'User',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Actualiza los campos permitidos del perfil en el backend (PUT /api/me/profile)
  Future<bool> updateProfile({
    required String name,
    required String organization,
    required String phone,
    required String gender,
    required String birthDate,
    required String country,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final token = await sessionStorage.getToken();
      if (token == null || token.isEmpty) return false;

      final data = await remoteDataSource.updateProfile(
        name: name,
        organization: organization,
        phone: phone,
        gender: gender,
        birthDate: birthDate,
        country: country,
        token: token,
      );

      state = state.copyWith(
        name: data['name'] as String? ?? name,
        organization: data['organization'] as String? ?? organization,
        phone: data['phone'] as String? ?? phone,
        gender: data['gender'] as String? ?? gender,
        birthDate: data['birthDate'] as String? ?? birthDate,
        country: data['country'] as String? ?? country,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}

/// Provider de Riverpod para consultar y actualizar el perfil
final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfileState>((ref) {
  final remoteDataSource = ref.watch(userProfileRemoteDataSourceProvider);
  final sessionStorage = ref.watch(sessionStorageProvider);
  return UserProfileNotifier(
    remoteDataSource: remoteDataSource,
    sessionStorage: sessionStorage,
  );
});
