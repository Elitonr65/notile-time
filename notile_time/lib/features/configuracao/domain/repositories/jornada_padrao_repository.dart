import '../entities/jornada_padrao.dart';

abstract class JornadaPadraoRepository {
  Future<JornadaPadrao?> get(String empresaId);

  Future<void> create(JornadaPadrao jornadaPadrao);

  Future<void> update(JornadaPadrao jornadaPadrao);
}
