import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../jornada/domain/entities/jornada.dart';
import '../../../jornada/presentation/providers/jornada_provider.dart';

class NotificacoesPage extends StatefulWidget {
  const NotificacoesPage({super.key});

  @override
  State<NotificacoesPage> createState() => _NotificacoesPageState();
}

class _NotificacoesPageState extends State<NotificacoesPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<JornadaProvider>().carregarHistorico();
    });
  }

  List<_Aviso> _avisos(List<Jornada> jornadas) {
    final hoje = DateTime.now();
    final hojeJornada = jornadas.where((jornada) {
      return jornada.data.year == hoje.year &&
          jornada.data.month == hoje.month &&
          jornada.data.day == hoje.day;
    }).toList();

    final atual = hojeJornada.isNotEmpty ? hojeJornada.first : null;
    final avisos = <_Aviso>[];

    if (atual == null) {
      avisos.add(
        const _Aviso(
          titulo: 'Entrada pendente',
          mensagem: 'Ainda nao existe registro de entrada para hoje.',
          icon: Icons.login,
          rota: '/ponto',
        ),
      );
    } else if (atual.status == 'aberta') {
      avisos.add(
        const _Aviso(
          titulo: 'Ponto em aberto',
          mensagem: 'Finalize a jornada ao encerrar o expediente.',
          icon: Icons.punch_clock,
          rota: '/ponto',
        ),
      );

      if (atual.inicioIntervalo == null) {
        avisos.add(
          const _Aviso(
            titulo: 'Intervalo nao iniciado',
            mensagem: 'Registre o intervalo quando sair para almoco.',
            icon: Icons.free_breakfast,
            rota: '/ponto',
          ),
        );
      } else if (atual.fimIntervalo == null) {
        avisos.add(
          const _Aviso(
            titulo: 'Retorno de intervalo pendente',
            mensagem: 'Registre o retorno para manter as horas corretas.',
            icon: Icons.play_arrow,
            rota: '/ponto',
          ),
        );
      }
    }

    final jornadasAbertas = jornadas
        .where((jornada) => jornada.status == 'aberta' && jornada.id != atual?.id)
        .length;

    if (jornadasAbertas > 0) {
      avisos.add(
        _Aviso(
          titulo: 'Jornadas antigas abertas',
          mensagem: '$jornadasAbertas registro(s) ainda precisam de revisao.',
          icon: Icons.warning_amber,
          rota: '/jornada/historico',
        ),
      );
    }

    final extrasMes = jornadas
        .where(
          (jornada) =>
              jornada.data.year == hoje.year && jornada.data.month == hoje.month,
        )
        .fold<double>(0, (total, jornada) => total + jornada.horasExtras);

    if (extrasMes > 0) {
      avisos.add(
        _Aviso(
          titulo: 'Horas extras no mes',
          mensagem: '${extrasMes.toStringAsFixed(2)}h extras registradas.',
          icon: Icons.trending_up,
          rota: '/relatorios',
        ),
      );
    }

    if (avisos.isEmpty) {
      avisos.add(
        const _Aviso(
          titulo: 'Tudo em dia',
          mensagem: 'Nao ha pendencias de ponto no momento.',
          icon: Icons.check_circle,
        ),
      );
    }

    return avisos;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JornadaProvider>();
    final avisos = _avisos(provider.jornadas);

    return Scaffold(
      appBar: AppBar(title: const Text('Notificacoes')),
      body: RefreshIndicator(
        onRefresh: provider.carregarHistorico,
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: avisos.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final aviso = avisos[index];

                  return Card(
                    child: ListTile(
                      leading: Icon(aviso.icon),
                      title: Text(aviso.titulo),
                      subtitle: Text(aviso.mensagem),
                      trailing: aviso.rota == null
                          ? null
                          : const Icon(Icons.arrow_forward_ios),
                      onTap: aviso.rota == null
                          ? null
                          : () => context.push(aviso.rota!),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _Aviso {
  const _Aviso({
    required this.titulo,
    required this.mensagem,
    required this.icon,
    this.rota,
  });

  final String titulo;
  final String mensagem;
  final IconData icon;
  final String? rota;
}
