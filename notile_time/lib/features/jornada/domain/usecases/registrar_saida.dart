import '../repositories/jornada_repository.dart';

class RegistrarSaida {
  final JornadaRepository repository;

  RegistrarSaida({required this.repository});

  Future<void> call() async {
    await repository.registrarSaida();
  }
}
