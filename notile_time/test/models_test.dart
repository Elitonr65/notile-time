import 'package:flutter_test/flutter_test.dart';
import 'package:notile_time/features/company/data/models/company_model.dart';
import 'package:notile_time/features/jornada/data/models/jornada_model.dart';
import 'package:notile_time/features/auth/data/models/user_model.dart';

void main() {
  group('UserModel', () {
    test('converte de e para mapa', () {
      final user = UserModel.fromMap({
        'id': 'user-1',
        'email': 'usuario@notile.app',
      });

      expect(user.id, 'user-1');
      expect(user.email, 'usuario@notile.app');
      expect(user.toMap(), {'id': 'user-1', 'email': 'usuario@notile.app'});
    });
  });

  group('CompanyModel', () {
    test('preserva os campos da empresa', () {
      final company = CompanyModel.fromMap({
        'id': 'company-1',
        'nome': 'Notile',
        'cnpj': '00.000.000/0001-00',
        'email': 'contato@notile.app',
        'telefone': '(11) 99999-9999',
        'criado_por': 'user-1',
      });

      expect(company.id, 'company-1');
      expect(company.nome, 'Notile');
      expect(company.criadoPor, 'user-1');
      expect(company.toMap(), {
        'nome': 'Notile',
        'cnpj': '00.000.000/0001-00',
        'email': 'contato@notile.app',
        'telefone': '(11) 99999-9999',
        'criado_por': 'user-1',
      });
    });
  });

  group('JornadaModel', () {
    test('converte datas e horas de jornada', () {
      final jornada = JornadaModel.fromMap({
        'id': 'jornada-1',
        'usuario_id': 'user-1',
        'empresa_id': 'company-1',
        'data': '2026-06-21',
        'entrada': '2026-06-21T08:00:00.000',
        'inicio_intervalo': '2026-06-21T12:00:00.000',
        'fim_intervalo': '2026-06-21T13:00:00.000',
        'saida': '2026-06-21T17:30:00.000',
        'total_horas': 8.5,
        'horas_extras': 0.5,
        'status': 'fechada',
      });

      expect(jornada.id, 'jornada-1');
      expect(jornada.usuarioId, 'user-1');
      expect(jornada.empresaId, 'company-1');
      expect(jornada.data, DateTime.parse('2026-06-21'));
      expect(jornada.entrada, DateTime.parse('2026-06-21T08:00:00.000'));
      expect(
        jornada.inicioIntervalo,
        DateTime.parse('2026-06-21T12:00:00.000'),
      );
      expect(jornada.fimIntervalo, DateTime.parse('2026-06-21T13:00:00.000'));
      expect(jornada.saida, DateTime.parse('2026-06-21T17:30:00.000'));
      expect(jornada.totalHoras, 8.5);
      expect(jornada.horasExtras, 0.5);
      expect(jornada.status, 'fechada');

      final map = jornada.toMap();

      expect(map['id'], 'jornada-1');
      expect(map['usuario_id'], 'user-1');
      expect(map['empresa_id'], 'company-1');
      expect(map['total_horas'], 8.5);
      expect(map['horas_extras'], 0.5);
      expect(map['status'], 'fechada');
    });
  });
}
