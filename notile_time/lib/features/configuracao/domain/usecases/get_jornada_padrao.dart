import '../entities/jornada_padrao.dart';
import '../repositories/jornada_padrao_repository.dart';

class GetJornadaPadrao {
  final JornadaPadraoRepository repository;

  GetJornadaPadrao(this.repository);

  Future<JornadaPadrao?> call(String empresaId) {
    return repository.get(empresaId);
  }
}
