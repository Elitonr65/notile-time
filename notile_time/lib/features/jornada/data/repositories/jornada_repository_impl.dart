import '../../domain/entities/jornada.dart';
import '../../domain/repositories/jornada_repository.dart';

import '../datasources/jornada_datasource.dart';

class JornadaRepositoryImpl implements JornadaRepository {
  final JornadaDatasource datasource;

  JornadaRepositoryImpl({required this.datasource});

  @override
  Future<void> registrarEntrada({required String empresaId}) async {
    await datasource.registrarEntrada(empresaId: empresaId);
  }

  @override
  Future<void> registrarInicioIntervalo() async {
    await datasource.registrarInicioIntervalo();
  }

  @override
  Future<void> registrarFimIntervalo() async {
    await datasource.registrarFimIntervalo();
  }

  @override
  Future<void> registrarSaida() async {
    await datasource.registrarSaida();
  }

  @override
  Future<List<Jornada>> getJornadas() async {
    return await datasource.buscarHistorico();
  }
}
