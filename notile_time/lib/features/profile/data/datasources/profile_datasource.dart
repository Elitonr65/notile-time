import '../models/profile_model.dart';

abstract class ProfileDatasource {
  Future<ProfileModel> getProfile();

  Future<void> updateProfile({
    required String nome,
    String? telefone,
    String? fotoUrl,
  });
}
