import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();

  Future<void> updateProfile({
    required String nome,
    String? telefone,
    String? fotoUrl,
  });
}
