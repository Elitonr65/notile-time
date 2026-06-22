import 'package:flutter/material.dart';

import '../../domain/entities/jornada_padrao.dart';

import '../../domain/usecases/get_jornada_padrao.dart';

import '../../domain/usecases/create_jornada_padrao.dart';

import '../../domain/usecases/update_jornada_padrao.dart';

class JornadaPadraoProvider extends ChangeNotifier {
  final GetJornadaPadrao get;

  final CreateJornadaPadrao create;

  final UpdateJornadaPadrao update;

  JornadaPadraoProvider({
    required this.get,

    required this.create,

    required this.update,
  });

  bool isLoading = false;

  JornadaPadrao? configuracao;

  String? errorMessage;

  Future<void> carregar(String empresaId) async {
    try {
      isLoading = true;

      notifyListeners();

      configuracao = await get(empresaId);
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> salvar(JornadaPadrao jornada) async {
    if (jornada.id == null) {
      await create(jornada);
    } else {
      await update(jornada);
    }

    configuracao = jornada;

    notifyListeners();
  }
}
