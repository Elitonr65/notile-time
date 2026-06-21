import 'package:flutter/material.dart';

import '../../domain/entities/jornada.dart';

import '../../domain/usecases/registrar_entrada.dart';
import '../../domain/usecases/registrar_inicio_intervalo.dart';
import '../../domain/usecases/registrar_fim_intervalo.dart';
import '../../domain/usecases/registrar_saida.dart';
import '../../domain/usecases/get_jornadas.dart';

class JornadaProvider extends ChangeNotifier {
  final RegistrarEntrada registrarEntradaUseCase;

  final RegistrarInicioIntervalo registrarInicioIntervaloUseCase;

  final RegistrarFimIntervalo registrarFimIntervaloUseCase;

  final RegistrarSaida registrarSaidaUseCase;

  final GetJornadas getJornadasUseCase;

  JornadaProvider({
    required this.registrarEntradaUseCase,

    required this.registrarInicioIntervaloUseCase,

    required this.registrarFimIntervaloUseCase,

    required this.registrarSaidaUseCase,

    required this.getJornadasUseCase,
  });

  bool isLoading = false;

  String? errorMessage;

  List<Jornada> jornadas = [];

  Jornada? jornadaAtual;

  Future<void> carregarHistorico() async {
    try {
      isLoading = true;

      notifyListeners();

      jornadas = await getJornadasUseCase();

      if (jornadas.isNotEmpty) {
        jornadaAtual = jornadas.firstWhere(
          (jornada) => jornada.status == 'aberta',

          orElse: () => jornadas.first,
        );
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> entrada({required String empresaId}) async {
    try {
      isLoading = true;

      notifyListeners();

      await registrarEntradaUseCase(empresaId: empresaId);

      await carregarHistorico();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> iniciarIntervalo() async {
    try {
      isLoading = true;

      notifyListeners();

      await registrarInicioIntervaloUseCase();

      await carregarHistorico();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> finalizarIntervalo() async {
    try {
      isLoading = true;

      notifyListeners();

      await registrarFimIntervaloUseCase();

      await carregarHistorico();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> saida() async {
    try {
      isLoading = true;

      notifyListeners();

      await registrarSaidaUseCase();

      await carregarHistorico();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  bool get jornadaAberta {
    return jornadaAtual?.status == 'aberta';
  }

  void limparErro() {
    errorMessage = null;

    notifyListeners();
  }
}
