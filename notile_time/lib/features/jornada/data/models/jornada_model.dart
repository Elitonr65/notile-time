import '../../domain/entities/jornada.dart';

class JornadaModel extends Jornada {
  JornadaModel({
    super.id,

    required super.usuarioId,

    required super.empresaId,

    required super.data,

    super.entrada,

    super.inicioIntervalo,

    super.fimIntervalo,

    super.saida,

    required super.totalHoras,

    required super.horasExtras,

    required super.status,
  });

  factory JornadaModel.fromMap(Map<String, dynamic> map) {
    return JornadaModel(
      id: map['id'],

      usuarioId: map['usuario_id'],

      empresaId: map['empresa_id'],

      data: DateTime.parse(map['data']),

      entrada: map['entrada'] != null ? DateTime.parse(map['entrada']) : null,

      inicioIntervalo: map['inicio_intervalo'] != null
          ? DateTime.parse(map['inicio_intervalo'])
          : null,

      fimIntervalo: map['fim_intervalo'] != null
          ? DateTime.parse(map['fim_intervalo'])
          : null,

      saida: map['saida'] != null ? DateTime.parse(map['saida']) : null,

      totalHoras: (map['total_horas'] ?? 0).toDouble(),

      horasExtras: (map['horas_extras'] ?? 0).toDouble(),

      status: map['status'] ?? 'aberta',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,

      'usuario_id': usuarioId,

      'empresa_id': empresaId,

      'data': data.toIso8601String(),

      'entrada': entrada?.toIso8601String(),

      'inicio_intervalo': inicioIntervalo?.toIso8601String(),

      'fim_intervalo': fimIntervalo?.toIso8601String(),

      'saida': saida?.toIso8601String(),

      'total_horas': totalHoras,

      'horas_extras': horasExtras,

      'status': status,
    };
  }
}
