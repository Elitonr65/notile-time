import '../entities/jornada.dart';

abstract class JornadaRepository {
  Future<void> registrarEntrada({required String empresaId});

  Future<void> registrarInicioIntervalo();

  Future<void> registrarFimIntervalo();

  Future<void> registrarSaida();

  Future<List<Jornada>> getJornadas();
}
