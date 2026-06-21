class JornadaPadrao {
  final String? id;

  final String empresaId;

  final String entradaPadrao;

  final String saidaPadrao;

  final double cargaHoraria;

  final double intervalo;

  final int tolerancia;

  const JornadaPadrao({
    this.id,
    required this.empresaId,
    required this.entradaPadrao,
    required this.saidaPadrao,
    required this.cargaHoraria,
    required this.intervalo,
    required this.tolerancia,
  });
}
