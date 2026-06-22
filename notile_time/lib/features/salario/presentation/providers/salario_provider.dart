import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../jornada/domain/entities/jornada.dart';
import '../../domain/entities/salario_resumo.dart';
import '../../domain/services/salario_calculator.dart';

class SalarioProvider extends ChangeNotifier {
  static const _valorHoraKey = 'salario_valor_hora';
  static const _multiplicadorExtraKey = 'salario_multiplicador_extra';
  static const _adicionaisKey = 'salario_adicionais';
  static const _descontosKey = 'salario_descontos';

  final SalarioCalculator calculator;

  SalarioProvider({this.calculator = const SalarioCalculator()});

  bool isLoading = false;
  double valorHora = 0;
  double multiplicadorExtra = 1.5;
  double adicionais = 0;
  double descontos = 0;

  Future<void> carregar() async {
    isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    valorHora = prefs.getDouble(_valorHoraKey) ?? 0;
    multiplicadorExtra = prefs.getDouble(_multiplicadorExtraKey) ?? 1.5;
    adicionais = prefs.getDouble(_adicionaisKey) ?? 0;
    descontos = prefs.getDouble(_descontosKey) ?? 0;

    isLoading = false;
    notifyListeners();
  }

  Future<void> salvar({
    required double valorHora,
    required double multiplicadorExtra,
    required double adicionais,
    required double descontos,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble(_valorHoraKey, valorHora);
    await prefs.setDouble(_multiplicadorExtraKey, multiplicadorExtra);
    await prefs.setDouble(_adicionaisKey, adicionais);
    await prefs.setDouble(_descontosKey, descontos);

    this.valorHora = valorHora;
    this.multiplicadorExtra = multiplicadorExtra;
    this.adicionais = adicionais;
    this.descontos = descontos;

    notifyListeners();
  }

  SalarioResumo calcular(List<Jornada> jornadas, DateTime periodo) {
    return calculator.calcular(
      jornadas: jornadas,
      periodo: periodo,
      valorHora: valorHora,
      multiplicadorExtra: multiplicadorExtra,
      adicionais: adicionais,
      descontos: descontos,
    );
  }
}
