import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/jornada_model.dart';

class JornadaDatasource {
  final SupabaseClient client;

  JornadaDatasource({required this.client});

  Future<JornadaModel?> buscarJornadaAberta() async {
    final usuarioId = client.auth.currentUser!.id;

    final response = await client
        .from('jornadas')
        .select()
        .eq('usuario_id', usuarioId)
        .eq('status', 'aberta')
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return JornadaModel.fromMap(response);
  }

  Future<void> registrarEntrada({required String empresaId}) async {
    final usuarioId = client.auth.currentUser!.id;

    final existente = await buscarJornadaAberta();

    if (existente != null) {
      throw Exception('Já existe uma jornada aberta');
    }

    await client.from('jornadas').insert({
      'usuario_id': usuarioId,

      'empresa_id': empresaId,

      'data': DateTime.now().toIso8601String().substring(0, 10),

      'entrada': DateTime.now().toIso8601String(),

      'status': 'aberta',
    });
  }

  Future<void> registrarInicioIntervalo() async {
    final jornada = await buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Nenhuma jornada aberta');
    }

    await client
        .from('jornadas')
        .update({'inicio_intervalo': DateTime.now().toIso8601String()})
        .eq('id', jornada.id!);
  }

  Future<void> registrarFimIntervalo() async {
    final jornada = await buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Nenhuma jornada aberta');
    }

    await client
        .from('jornadas')
        .update({'fim_intervalo': DateTime.now().toIso8601String()})
        .eq('id', jornada.id!);
  }

  Future<void> registrarSaida() async {
    final jornada = await buscarJornadaAberta();

    if (jornada == null) {
      throw Exception('Nenhuma jornada aberta');
    }

    final agora = DateTime.now();

    final entrada = jornada.entrada;

    if (entrada == null) {
      throw Exception('Entrada inválida');
    }

    Duration trabalhado = agora.difference(entrada);

    if (jornada.inicioIntervalo != null && jornada.fimIntervalo != null) {
      final intervalo = jornada.fimIntervalo!.difference(
        jornada.inicioIntervalo!,
      );

      trabalhado -= intervalo;
    }

    double totalHoras = trabalhado.inMinutes / 60;

    double extras = 0;

    if (totalHoras > 8) {
      extras = totalHoras - 8;
    }

    await client
        .from('jornadas')
        .update({
          'saida': agora.toIso8601String(),

          'total_horas': totalHoras,

          'horas_extras': extras,

          'status': 'fechada',
        })
        .eq('id', jornada.id!);
  }

  Future<List<JornadaModel>> buscarHistorico() async {
    final usuarioId = client.auth.currentUser!.id;

    final response = await client
        .from('jornadas')
        .select()
        .eq('usuario_id', usuarioId)
        .order('data', ascending: false);

    return response
        .map<JornadaModel>((item) => JornadaModel.fromMap(item))
        .toList();
  }
}
