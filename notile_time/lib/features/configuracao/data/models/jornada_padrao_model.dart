import '../../domain/entities/jornada_padrao.dart';

class JornadaPadraoModel extends JornadaPadrao {
  const JornadaPadraoModel({
    super.id,
    required super.empresaId,
    required super.entradaPadrao,
    required super.saidaPadrao,
    required super.cargaHoraria,
    required super.intervalo,
    required super.tolerancia,
  });

  factory JornadaPadraoModel.fromMap(Map<String, dynamic> map) {
    return JornadaPadraoModel(
      id: map['id'],
      empresaId: map['empresa_id'],
      entradaPadrao: map['entrada_padrao'],
      saidaPadrao: map['saida_padrao'],
      cargaHoraria: (map['carga_horaria'] as num).toDouble(),
      intervalo: (map['intervalo'] as num).toDouble(),
      tolerancia: map['tolerancia'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'empresa_id': empresaId,
      'entrada_padrao': entradaPadrao,
      'saida_padrao': saidaPadrao,
      'carga_horaria': cargaHoraria,
      'intervalo': intervalo,
      'tolerancia': tolerancia,
    };
  }
}
