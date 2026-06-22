import '../../../jornada/domain/entities/jornada.dart';
import '../entities/salario_resumo.dart';

class SalarioCalculator {
  const SalarioCalculator();

  SalarioResumo calcular({
    required List<Jornada> jornadas,
    required DateTime periodo,
    required double valorHora,
    required double multiplicadorExtra,
    required double adicionais,
    required double descontos,
  }) {
    final jornadasDoMes = jornadas.where(
      (jornada) =>
          jornada.data.year == periodo.year &&
          jornada.data.month == periodo.month,
    );

    double horasNormais = 0;
    double horasExtras = 0;

    for (final jornada in jornadasDoMes) {
      final extras = jornada.horasExtras < 0 ? 0 : jornada.horasExtras;
      final normais = jornada.totalHoras - extras;

      horasNormais += normais < 0 ? 0 : normais;
      horasExtras += extras;
    }

    return SalarioResumo(
      horasNormais: horasNormais,
      horasExtras: horasExtras,
      valorNormal: horasNormais * valorHora,
      valorExtra: horasExtras * valorHora * multiplicadorExtra,
      adicionais: adicionais,
      descontos: descontos,
    );
  }
}
