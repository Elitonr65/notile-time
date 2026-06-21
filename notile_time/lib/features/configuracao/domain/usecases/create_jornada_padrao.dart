import '../entities/jornada_padrao.dart';
import '../repositories/jornada_padrao_repository.dart';

class CreateJornadaPadrao {
  final JornadaPadraoRepository repository;

  CreateJornadaPadrao(this.repository);

  Future<void> call(JornadaPadrao jornada) {
    return repository.create(jornada);
  }
}
