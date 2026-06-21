class Jornada {
  final String? id;

  final String usuarioId;

  final String empresaId;

  final DateTime data;

  final DateTime? entrada;

  final DateTime? inicioIntervalo;

  final DateTime? fimIntervalo;

  final DateTime? saida;

  final double totalHoras;

  final double horasExtras;

  final String status;

  Jornada({
    this.id,

    required this.usuarioId,

    required this.empresaId,

    required this.data,

    this.entrada,

    this.inicioIntervalo,

    this.fimIntervalo,

    this.saida,

    required this.totalHoras,

    required this.horasExtras,

    required this.status,
  });
}
