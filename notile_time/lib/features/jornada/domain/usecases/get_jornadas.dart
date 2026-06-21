import '../entities/jornada.dart';

import '../repositories/jornada_repository.dart';

class GetJornadas {
  final JornadaRepository repository;

  GetJornadas({required this.repository});

  Future<List<Jornada>> call() async {
    return await repository.getJornadas();
  }
}
