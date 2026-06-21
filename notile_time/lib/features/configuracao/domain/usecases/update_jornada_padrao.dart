import '../entities/jornada_padrao.dart';
import '../repositories/jornada_padrao_repository.dart';

class UpdateJornadaPadrao {
  final JornadaPadraoRepository repository;

  UpdateJornadaPadrao(this.repository);

  Future<void> call(JornadaPadrao jornada) {
    return repository.update(jornada);
  }
}
