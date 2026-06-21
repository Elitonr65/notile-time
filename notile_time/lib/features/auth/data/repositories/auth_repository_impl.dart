import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<UserEntity?> signUp({
    required String email,
    required String password,
  }) async {
    return await datasource.signUp(email: email, password: password);
  }

  @override
  Future<UserEntity?> signIn({
    required String email,
    required String password,
  }) async {
    return await datasource.signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await datasource.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await datasource.resetPassword(email: email);
  }

  @override
  UserEntity? getCurrentUser() {
    return datasource.getCurrentUser();
  }
}
