import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_model.dart';
import 'auth_datasource.dart';

class AuthDatasourceImpl implements AuthDatasource {
  final SupabaseClient client;

  AuthDatasourceImpl(this.client);

  @override
  Future<UserModel?> signUp({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signUp(email: email, password: password);

    final user = response.user;

    if (user == null) {
      return null;
    }

    return UserModel(id: user.id, email: user.email ?? '');
  }

  @override
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;

    if (user == null) {
      return null;
    }

    return UserModel(id: user.id, email: user.email ?? '');
  }

  @override
  Future<void> signOut() async {
    await client.auth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await client.auth.resetPasswordForEmail(email);
  }

  @override
  UserModel? getCurrentUser() {
    final user = client.auth.currentUser;

    if (user == null) {
      return null;
    }

    return UserModel(id: user.id, email: user.email ?? '');
  }
}
