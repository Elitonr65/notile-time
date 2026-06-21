import '../repositories/jornada_repository.dart';

class RegistrarInicioIntervalo {
  final JornadaRepository repository;

  RegistrarInicioIntervalo({required this.repository});

  Future<void> call() async {
    await repository.registrarInicioIntervalo();
  }
}
