import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl(this.datasource);

  @override
  Future<ProfileEntity> getProfile() {
    return datasource.getProfile();
  }

  @override
  Future<void> updateProfile({
    required String nome,
    String? telefone,
    String? fotoUrl,
  }) {
    return datasource.updateProfile(
      nome: nome,
      telefone: telefone,
      fotoUrl: fotoUrl,
    );
  }
}
