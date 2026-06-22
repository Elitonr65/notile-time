class SalarioResumo {
  const SalarioResumo({
    required this.horasNormais,
    required this.horasExtras,
    required this.valorNormal,
    required this.valorExtra,
    required this.adicionais,
    required this.descontos,
  });

  final double horasNormais;
  final double horasExtras;
  final double valorNormal;
  final double valorExtra;
  final double adicionais;
  final double descontos;

  double get bruto => valorNormal + valorExtra + adicionais;

  double get liquido => bruto - descontos;
}
