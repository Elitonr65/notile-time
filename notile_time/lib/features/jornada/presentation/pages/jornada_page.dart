import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/jornada_provider.dart';

import '../../../company/presentation/providers/company_provider.dart';

class JornadaPage extends StatefulWidget {
  const JornadaPage({super.key});

  @override
  State<JornadaPage> createState() => _JornadaPageState();
}

class _JornadaPageState extends State<JornadaPage> {
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

  String formatarHora(DateTime? data) {
    if (data == null) {
      return "--:--";
    }

    return "${data.hour.toString().padLeft(2, '0')}:"
        "${data.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final jornadaProvider = context.watch<JornadaProvider>();

    final companyProvider = context.watch<CompanyProvider>();

    final jornada = jornadaProvider.jornadaAtual;

    final empresaId = companyProvider.company?.id;

    return Scaffold(
      appBar: AppBar(title: const Text("Minha Jornada")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      "Status: "
                      "${jornada?.status ?? 'Sem jornada'}",
                    ),

                    Text(
                      "Entrada: "
                      "${formatarHora(jornada?.entrada)}",
                    ),

                    Text(
                      "Início almoço: "
                      "${formatarHora(jornada?.inicioIntervalo)}",
                    ),

                    Text(
                      "Fim almoço: "
                      "${formatarHora(jornada?.fimIntervalo)}",
                    ),

                    Text(
                      "Saída: "
                      "${formatarHora(jornada?.saida)}",
                    ),

                    Text(
                      "Horas: ${jornada?.totalHoras.toStringAsFixed(2) ?? '0'}",
                    ),

                    Text(
                      "Extras: ${jornada?.horasExtras.toStringAsFixed(2) ?? '0'}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (jornadaProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              ElevatedButton.icon(
                icon: const Icon(Icons.login),

                label: const Text("Entrada"),

                onPressed: jornadaProvider.jornadaAberta
                    ? null
                    : empresaId == null
                    ? null
                    : () {
                        jornadaProvider.entrada(empresaId: empresaId);
                      },
              ),

              ElevatedButton.icon(
                icon: const Icon(Icons.restaurant),

                label: const Text("Iniciar almoço"),

                onPressed: !jornadaProvider.jornadaAberta
                    ? null
                    : () {
                        jornadaProvider.iniciarIntervalo();
                      },
              ),

              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),

                label: const Text("Retorno almoço"),

                onPressed: !jornadaProvider.jornadaAberta
                    ? null
                    : () {
                        jornadaProvider.finalizarIntervalo();
                      },
              ),

              ElevatedButton.icon(
                icon: const Icon(Icons.logout),

                label: const Text("Saída"),

                onPressed: !jornadaProvider.jornadaAberta
                    ? null
                    : () {
                        jornadaProvider.saida();
                      },
              ),
            ],

            if (jornadaProvider.errorMessage != null)
              Text(
                jornadaProvider.errorMessage!,

                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
