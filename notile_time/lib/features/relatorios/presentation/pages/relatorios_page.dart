import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../../../jornada/domain/entities/jornada.dart';
import '../../../jornada/presentation/providers/jornada_provider.dart';

class RelatoriosPage extends StatefulWidget {
  const RelatoriosPage({super.key});

  @override
  State<RelatoriosPage> createState() => _RelatoriosPageState();
}

class _RelatoriosPageState extends State<RelatoriosPage> {
  DateTime periodo = DateTime(DateTime.now().year, DateTime.now().month);

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

  List<Jornada> _jornadasDoMes(List<Jornada> jornadas) {
    return jornadas
        .where(
          (jornada) =>
              jornada.data.year == periodo.year &&
              jornada.data.month == periodo.month,
        )
        .toList();
  }

  _ResumoRelatorio _resumo(List<Jornada> jornadas) {
    final totalHoras = jornadas.fold<double>(
      0,
      (total, jornada) => total + jornada.totalHoras,
    );

    final horasExtras = jornadas.fold<double>(
      0,
      (total, jornada) => total + jornada.horasExtras,
    );

    return _ResumoRelatorio(
      dias: jornadas.where((jornada) => jornada.entrada != null).length,
      fechadas: jornadas.where((jornada) => jornada.status == 'fechada').length,
      abertas: jornadas.where((jornada) => jornada.status == 'aberta').length,
      totalHoras: totalHoras,
      horasExtras: horasExtras,
    );
  }

  Future<void> _mudarMes(int delta) async {
    setState(() {
      periodo = DateTime(periodo.year, periodo.month + delta);
    });
  }

  Future<void> _exportarPdf(List<Jornada> jornadas) async {
    final bytes = await _gerarPdf(jornadas);
    final nome = 'relatorio_${periodo.year}_${periodo.month}.pdf';

    await Printing.sharePdf(bytes: bytes, filename: nome);
  }

  Future<Uint8List> _gerarPdf(List<Jornada> jornadas) async {
    final pdf = pw.Document();
    final resumo = _resumo(jornadas);
    final formatoData = DateFormat('dd/MM/yyyy');

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Text(
            'Relatorio de ponto',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 8),
          pw.Text(DateFormat('MM/yyyy').format(periodo)),
          pw.SizedBox(height: 16),
          pw.Text('Dias trabalhados: ${resumo.dias}'),
          pw.Text('Horas totais: ${resumo.totalHoras.toStringAsFixed(2)}'),
          pw.Text('Horas extras: ${resumo.horasExtras.toStringAsFixed(2)}'),
          pw.Text('Jornadas fechadas: ${resumo.fechadas}'),
          pw.Text('Jornadas abertas: ${resumo.abertas}'),
          pw.SizedBox(height: 16),
          pw.TableHelper.fromTextArray(
            headers: [
              'Data',
              'Entrada',
              'Saida',
              'Horas',
              'Extras',
              'Status',
            ],
            data: jornadas
                .map(
                  (jornada) => [
                    formatoData.format(jornada.data),
                    _hora(jornada.entrada),
                    _hora(jornada.saida),
                    jornada.totalHoras.toStringAsFixed(2),
                    jornada.horasExtras.toStringAsFixed(2),
                    jornada.status,
                  ],
                )
                .toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  String _hora(DateTime? data) {
    if (data == null) {
      return '--:--';
    }

    return '${data.hour.toString().padLeft(2, '0')}:'
        '${data.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JornadaProvider>();
    final jornadas = _jornadasDoMes(provider.jornadas);
    final resumo = _resumo(jornadas);
    final formatoMes = DateFormat('MM/yyyy');
    final formatoData = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: AppBar(title: const Text('Relatorios')),
      body: RefreshIndicator(
        onRefresh: provider.carregarHistorico,
        child: ListView(
          padding: const EdgeInsets.all(16),
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
                      formatoMes.format(periodo),
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
            const SizedBox(height: 12),
            if (provider.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              _ResumoGrid(resumo: resumo),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: jornadas.isEmpty ? null : () => _exportarPdf(jornadas),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Exportar PDF'),
              ),
              const SizedBox(height: 16),
              if (jornadas.isEmpty)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('Sem registros no periodo'),
                  ),
                )
              else
                ...jornadas.map(
                  (jornada) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.event_note),
                      title: Text(formatoData.format(jornada.data)),
                      subtitle: Text(
                        'Entrada ${_hora(jornada.entrada)} | '
                        'Saida ${_hora(jornada.saida)}',
                      ),
                      trailing: Text(
                        '${jornada.totalHoras.toStringAsFixed(2)}h',
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResumoGrid extends StatelessWidget {
  const _ResumoGrid({required this.resumo});

  final _ResumoRelatorio resumo;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: MediaQuery.sizeOf(context).width > 600 ? 4 : 2,
      childAspectRatio: 1.75,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        _ResumoCard(label: 'Dias', value: resumo.dias.toString()),
        _ResumoCard(
          label: 'Horas',
          value: resumo.totalHoras.toStringAsFixed(2),
        ),
        _ResumoCard(
          label: 'Extras',
          value: resumo.horasExtras.toStringAsFixed(2),
        ),
        _ResumoCard(label: 'Abertas', value: resumo.abertas.toString()),
      ],
    );
  }
}

class _ResumoCard extends StatelessWidget {
  const _ResumoCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResumoRelatorio {
  const _ResumoRelatorio({
    required this.dias,
    required this.fechadas,
    required this.abertas,
    required this.totalHoras,
    required this.horasExtras,
  });

  final int dias;
  final int fechadas;
  final int abertas;
  final double totalHoras;
  final double horasExtras;
}
