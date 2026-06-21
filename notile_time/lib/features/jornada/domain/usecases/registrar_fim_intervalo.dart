import '../repositories/jornada_repository.dart';

class RegistrarFimIntervalo {
  final JornadaRepository repository;

  RegistrarFimIntervalo({required this.repository});

  Future<void> call() async {
    await repository.registrarFimIntervalo();
  }
}
