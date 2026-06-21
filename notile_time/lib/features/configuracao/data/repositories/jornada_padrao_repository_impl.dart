import '../../domain/entities/jornada_padrao.dart';
import '../../domain/repositories/jornada_padrao_repository.dart';

import '../datasources/jornada_padrao_datasource.dart';
import '../models/jornada_padrao_model.dart';

class JornadaPadraoRepositoryImpl implements JornadaPadraoRepository {
  final JornadaPadraoDatasource datasource;

  JornadaPadraoRepositoryImpl(this.datasource);

  @override
  Future<JornadaPadrao?> get(String empresaId) {
    return datasource.get(empresaId);
  }

  @override
  Future<void> create(JornadaPadrao jornada) {
    return datasource.create(
      JornadaPadraoModel(
        empresaId: jornada.empresaId,
        entradaPadrao: jornada.entradaPadrao,
        saidaPadrao: jornada.saidaPadrao,
        cargaHoraria: jornada.cargaHoraria,
        intervalo: jornada.intervalo,
        tolerancia: jornada.tolerancia,
      ),
    );
  }

  @override
  Future<void> update(JornadaPadrao jornada) {
    return datasource.update(
      JornadaPadraoModel(
        id: jornada.id,
        empresaId: jornada.empresaId,
        entradaPadrao: jornada.entradaPadrao,
        saidaPadrao: jornada.saidaPadrao,
        cargaHoraria: jornada.cargaHoraria,
        intervalo: jornada.intervalo,
        tolerancia: jornada.tolerancia,
      ),
    );
  }
}
