import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../company/presentation/providers/company_provider.dart';
import '../../domain/entities/jornada_padrao.dart';
import '../providers/jornada_padrao_provider.dart';

class JornadaConfigPage extends StatefulWidget {
  const JornadaConfigPage({super.key});

  @override
  State<JornadaConfigPage> createState() => _JornadaConfigPageState();
}

class _JornadaConfigPageState extends State<JornadaConfigPage> {
  final entradaController = TextEditingController(text: '08:00');
  final saidaController = TextEditingController(text: '17:00');
  final cargaController = TextEditingController(text: '8');
  final intervaloController = TextEditingController(text: '1');
  final toleranciaController = TextEditingController(text: '10');

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
    final companyProvider = context.read<CompanyProvider>();

    await companyProvider.loadCompany();

    final company = companyProvider.company;

    if (!mounted || company == null) {
      return;
    }

    await context.read<JornadaPadraoProvider>().carregar(company.id);

    if (!mounted) {
      return;
    }

    _preencherCampos(context.read<JornadaPadraoProvider>());
  }

  void _preencherCampos(JornadaPadraoProvider provider) {
    if (camposPreenchidos || provider.configuracao == null) {
      return;
    }

    final configuracao = provider.configuracao!;

    entradaController.text = configuracao.entradaPadrao;
    saidaController.text = configuracao.saidaPadrao;
    cargaController.text = configuracao.cargaHoraria.toStringAsFixed(2);
    intervaloController.text = configuracao.intervalo.toStringAsFixed(2);
    toleranciaController.text = configuracao.tolerancia.toString();
    camposPreenchidos = true;
  }

  double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '.').trim()) ?? 0;
  }

  int _parseInt(String value) {
    return int.tryParse(value.trim()) ?? 0;
  }

  Future<void> _salvar() async {
    final company = context.read<CompanyProvider>().company;

    if (company == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastre uma empresa antes.')),
      );

      return;
    }

    final provider = context.read<JornadaPadraoProvider>();
    final atual = provider.configuracao;

    final jornada = JornadaPadrao(
      id: atual?.id,
      empresaId: company.id,
      entradaPadrao: entradaController.text.trim(),
      saidaPadrao: saidaController.text.trim(),
      cargaHoraria: _parseDouble(cargaController.text),
      intervalo: _parseDouble(intervaloController.text),
      tolerancia: _parseInt(toleranciaController.text),
    );

    await provider.salvar(jornada);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Configuracao de jornada salva.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final companyProvider = context.watch<CompanyProvider>();
    final jornadaProvider = context.watch<JornadaPadraoProvider>();

    _preencherCampos(jornadaProvider);

    final isLoading = companyProvider.isLoading || jornadaProvider.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuracao de jornada')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (companyProvider.company == null)
                    const Card(
                      child: ListTile(
                        leading: Icon(Icons.business),
                        title: Text('Empresa nao encontrada'),
                        subtitle: Text(
                          'Cadastre uma empresa para salvar a jornada padrao.',
                        ),
                      ),
                    ),
                  TextField(
                    controller: entradaController,
                    decoration: const InputDecoration(
                      labelText: 'Entrada padrao',
                      hintText: '08:00',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: saidaController,
                    decoration: const InputDecoration(
                      labelText: 'Saida padrao',
                      hintText: '17:00',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: cargaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Carga horaria diaria',
                      suffixText: 'h',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: intervaloController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Intervalo padrao',
                      suffixText: 'h',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: toleranciaController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tolerancia',
                      suffixText: 'min',
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: companyProvider.company == null ? null : _salvar,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar configuracao'),
                  ),
                  if (jornadaProvider.errorMessage != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      jornadaProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    entradaController.dispose();
    saidaController.dispose();
    cargaController.dispose();
    intervaloController.dispose();
    toleranciaController.dispose();
    super.dispose();
  }
}
