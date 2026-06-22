import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../jornada/presentation/providers/jornada_provider.dart';
import '../providers/salario_provider.dart';

class SalarioPage extends StatefulWidget {
  const SalarioPage({super.key});

  @override
  State<SalarioPage> createState() => _SalarioPageState();
}

class _SalarioPageState extends State<SalarioPage> {
  final valorHoraController = TextEditingController();
  final extraController = TextEditingController();
  final adicionaisController = TextEditingController();
  final descontosController = TextEditingController();

  DateTime periodo = DateTime(DateTime.now().year, DateTime.now().month);
  bool camposPreenchidos = false;

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
    await Future.wait([
      context.read<SalarioProvider>().carregar(),
      context.read<JornadaProvider>().carregarHistorico(),
    ]);

    if (!mounted) {
      return;
    }

    _preencherCampos(context.read<SalarioProvider>());
  }

  void _preencherCampos(SalarioProvider provider) {
    if (camposPreenchidos || provider.isLoading) {
      return;
    }

    valorHoraController.text = provider.valorHora.toStringAsFixed(2);
    extraController.text = provider.multiplicadorExtra.toStringAsFixed(2);
    adicionaisController.text = provider.adicionais.toStringAsFixed(2);
    descontosController.text = provider.descontos.toStringAsFixed(2);
    camposPreenchidos = true;
  }

  double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.').trim()) ?? 0;
  }

  Future<void> _salvar() async {
    await context.read<SalarioProvider>().salvar(
          valorHora: _parseDouble(valorHoraController.text),
          multiplicadorExtra: _parseDouble(extraController.text),
          adicionais: _parseDouble(adicionaisController.text),
          descontos: _parseDouble(descontosController.text),
        );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Parametros de salario salvos.')),
    );
  }

  void _mudarMes(int delta) {
    setState(() {
      periodo = DateTime(periodo.year, periodo.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final salarioProvider = context.watch<SalarioProvider>();
    final jornadaProvider = context.watch<JornadaProvider>();

    _preencherCampos(salarioProvider);

    final resumo = salarioProvider.calcular(jornadaProvider.jornadas, periodo);
    final moeda = NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
    final mes = DateFormat('MM/yyyy').format(periodo);
    final carregando = salarioProvider.isLoading || jornadaProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Salario')),
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => _mudarMes(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      mes,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _mudarMes(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            if (carregando)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else ...[
              _ValorCard(
                titulo: 'Salario liquido estimado',
                valor: moeda.format(resumo.liquido),
                destaque: true,
              ),
              const SizedBox(height: 12),
              _ValorCard(
                titulo: 'Bruto',
                valor: moeda.format(resumo.bruto),
              ),
              _ValorCard(
                titulo: 'Horas normais',
                valor:
                    '${resumo.horasNormais.toStringAsFixed(2)}h | ${moeda.format(resumo.valorNormal)}',
              ),
              _ValorCard(
                titulo: 'Horas extras',
                valor:
                    '${resumo.horasExtras.toStringAsFixed(2)}h | ${moeda.format(resumo.valorExtra)}',
              ),
              _ValorCard(
                titulo: 'Descontos',
                valor: moeda.format(resumo.descontos),
              ),
              const SizedBox(height: 20),
              Text(
                'Parametros',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: valorHoraController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor por hora',
                  prefixText: r'R$ ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: extraController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Multiplicador de hora extra',
                  hintText: '1.5',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: adicionaisController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Adicionais do mes',
                  prefixText: r'R$ ',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descontosController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Descontos do mes',
                  prefixText: r'R$ ',
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: const Text('Salvar parametros'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    valorHoraController.dispose();
    extraController.dispose();
    adicionaisController.dispose();
    descontosController.dispose();
    super.dispose();
  }
}

class _ValorCard extends StatelessWidget {
  const _ValorCard({
    required this.titulo,
    required this.valor,
    this.destaque = false,
  });

  final String titulo;
  final String valor;
  final bool destaque;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor,
          style: destaque
              ? Theme.of(context).textTheme.titleMedium
              : Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
