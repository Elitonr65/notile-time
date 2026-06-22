import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../../jornada/domain/entities/jornada.dart';
import '../../../jornada/presentation/providers/jornada_provider.dart';

class PontoPage extends StatefulWidget {
  const PontoPage({super.key});

  @override
  State<PontoPage> createState() => _PontoPageState();
}

class _PontoPageState extends State<PontoPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _carregar();
    });
  }

  Future<void> _carregar() async {
    await context.read<CompanyProvider>().loadCompany();

    if (!mounted) {
      return;
    }

    await context.read<JornadaProvider>().carregarHistorico();
  }

  String _hora(DateTime? data) {
    if (data == null) {
      return '--:--';
    }

    return '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  String _data(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  Future<void> _executar(Future<void> Function() action) async {
    await action();

    if (!mounted) {
      return;
    }

    final error = context.read<JornadaProvider>().errorMessage;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error == null ? 'Ponto registrado.' : error),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final jornadaProvider = context.watch<JornadaProvider>();
    final jornada = jornadaProvider.jornadaAtual;
    final empresaId = companyProvider.company?.id;
    final carregando = companyProvider.isLoading || jornadaProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Ponto')),
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (companyProvider.company == null)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Empresa nao vinculada'),
                  subtitle: const Text(
                    'Cadastre a empresa para liberar o registro de ponto.',
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => context.push('/company'),
                ),
              ),
            if (carregando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _ResumoPontoCard(
                jornada: jornada,
                hora: _hora,
                data: _data,
              ),
              const SizedBox(height: 16),
              _PontoActions(
                jornadaProvider: jornadaProvider,
                empresaId: empresaId,
                executar: _executar,
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.push('/jornada/historico'),
                icon: const Icon(Icons.history),
                label: const Text('Ver historico'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResumoPontoCard extends StatelessWidget {
  const _ResumoPontoCard({
    required this.jornada,
    required this.hora,
    required this.data,
  });

  final Jornada? jornada;
  final String Function(DateTime?) hora;
  final String Function(DateTime) data;

  @override
  Widget build(BuildContext context) {
    final status = jornada?.status ?? 'sem registro';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.punch_clock),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Status: $status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text('Data: ${jornada == null ? '--/--/----' : data(jornada!.data)}'),
            Text('Entrada: ${hora(jornada?.entrada)}'),
            Text('Inicio intervalo: ${hora(jornada?.inicioIntervalo)}'),
            Text('Fim intervalo: ${hora(jornada?.fimIntervalo)}'),
            Text('Saida: ${hora(jornada?.saida)}'),
            const SizedBox(height: 8),
            Text(
              'Horas: ${jornada?.totalHoras.toStringAsFixed(2) ?? '0.00'}',
            ),
            Text(
              'Extras: ${jornada?.horasExtras.toStringAsFixed(2) ?? '0.00'}',
            ),
          ],
        ),
      ),
    );
  }
}

class _PontoActions extends StatelessWidget {
  const _PontoActions({
    required this.jornadaProvider,
    required this.empresaId,
    required this.executar,
  });

  final JornadaProvider jornadaProvider;
  final String? empresaId;
  final Future<void> Function(Future<void> Function() action) executar;

  @override
  Widget build(BuildContext context) {
    final aberta = jornadaProvider.jornadaAberta;
    final jornada = jornadaProvider.jornadaAtual;
    final emIntervalo =
        jornada?.inicioIntervalo != null && jornada?.fimIntervalo == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.login),
          label: const Text('Registrar entrada'),
          onPressed: aberta || empresaId == null
              ? null
              : () => executar(
                    () => jornadaProvider.entrada(empresaId: empresaId!),
                  ),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.free_breakfast),
          label: const Text('Iniciar intervalo'),
          onPressed: !aberta || emIntervalo
              ? null
              : () => executar(jornadaProvider.iniciarIntervalo),
        ),
        const SizedBox(height: 10),
        FilledButton.tonalIcon(
          icon: const Icon(Icons.play_arrow),
          label: const Text('Finalizar intervalo'),
          onPressed: !aberta || !emIntervalo
              ? null
              : () => executar(jornadaProvider.finalizarIntervalo),
        ),
        const SizedBox(height: 10),
        FilledButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Registrar saida'),
          onPressed: !aberta ? null : () => executar(jornadaProvider.saida),
        ),
      ],
    );
  }
}
