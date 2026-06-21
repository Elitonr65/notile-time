import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import 'profile_datasource.dart';

class ProfileDatasourceImpl implements ProfileDatasource {
  final SupabaseClient client;

  ProfileDatasourceImpl(this.client);

  @override
  Future<ProfileModel> getProfile() async {
    final user = client.auth.currentUser!;

    final response = await client
        .from('usuarios')
        .select()
        .eq('id', user.id)
        .single();

    return ProfileModel.fromMap(response);
  }

  @override
  Future<void> updateProfile({
    required String nome,
    String? telefone,
    String? fotoUrl,
  }) async {
    final user = client.auth.currentUser!;

    await client
        .from('usuarios')
        .update({'nome': nome, 'telefone': telefone, 'foto_url': fotoUrl})
        .eq('id', user.id);
  }
}
