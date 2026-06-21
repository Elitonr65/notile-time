import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/jornada_provider.dart';

class HistoricoJornadaPage extends StatefulWidget {
  const HistoricoJornadaPage({super.key});

  @override
  State<HistoricoJornadaPage> createState() => _HistoricoJornadaPageState();
}

class _HistoricoJornadaPageState extends State<HistoricoJornadaPage> {
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

  String formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  String formatarHora(DateTime? data) {
    if (data == null) {
      return "--:--";
    }

    return "${data.hour.toString().padLeft(2, '0')}:"
        "${data.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<JornadaProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Histórico de Jornadas")),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.jornadas.isEmpty
          ? const Center(child: Text("Nenhuma jornada registrada"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: provider.jornadas.length,

              itemBuilder: (context, index) {
                final jornada = provider.jornadas[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          formatarData(jornada.data),

                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),

                        Text("Entrada: ${formatarHora(jornada.entrada)}"),

                        Text(
                          "Início almoço: ${formatarHora(jornada.inicioIntervalo)}",
                        ),

                        Text(
                          "Fim almoço: ${formatarHora(jornada.fimIntervalo)}",
                        ),

                        Text("Saída: ${formatarHora(jornada.saida)}"),

                        Text(
                          "Horas trabalhadas: "
                          "${jornada.totalHoras.toStringAsFixed(2)}",
                        ),

                        Text(
                          "Horas extras: "
                          "${jornada.horasExtras.toStringAsFixed(2)}",
                        ),

                        Text("Status: ${jornada.status}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
