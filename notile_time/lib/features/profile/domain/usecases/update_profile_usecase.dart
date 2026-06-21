import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<void> call({required String nome, String? telefone, String? fotoUrl}) {
    return repository.updateProfile(
      nome: nome,
      telefone: telefone,
      fotoUrl: fotoUrl,
    );
  }
}
