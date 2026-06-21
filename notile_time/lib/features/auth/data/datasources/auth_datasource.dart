import '../models/user_model.dart';

abstract class AuthDatasource {
  Future<UserModel?> signUp({required String email, required String password});

  Future<UserModel?> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> resetPassword({required String email});

  UserModel? getCurrentUser();
}
