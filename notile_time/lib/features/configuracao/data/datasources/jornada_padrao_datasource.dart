import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/jornada_padrao_model.dart';

class JornadaPadraoDatasource {
  final SupabaseClient client;

  JornadaPadraoDatasource(this.client);

  Future<JornadaPadraoModel?> get(String empresaId) async {
    final response = await client
        .from('jornadas_padrao')
        .select()
        .eq('empresa_id', empresaId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return JornadaPadraoModel.fromMap(response);
  }

  Future<void> create(JornadaPadraoModel model) async {
    await client.from('jornadas_padrao').insert(model.toMap());
  }

  Future<void> update(JornadaPadraoModel model) async {
    await client
        .from('jornadas_padrao')
        .update(model.toMap())
        .eq('id', model.id!);
  }
}
