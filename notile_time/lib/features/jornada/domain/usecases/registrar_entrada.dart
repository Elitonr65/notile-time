import '../repositories/jornada_repository.dart';

class RegistrarEntrada {
  final JornadaRepository repository;

  RegistrarEntrada({required this.repository});

  Future<void> call({required String empresaId}) async {
    await repository.registrarEntrada(empresaId: empresaId);
  }
}
