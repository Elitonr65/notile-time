import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/company_provider.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({super.key});

  @override
  State<CompanyPage> createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  final nomeController = TextEditingController();

  final cnpjController = TextEditingController();

  final emailController = TextEditingController();

  final telefoneController = TextEditingController();

  bool camposPreenchidos = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _loadCompany();
    });
  }

  Future<void> _loadCompany() async {
    final provider = context.read<CompanyProvider>();

    await provider.loadCompany();

    if (!mounted) {
      return;
    }

    preencherCampos(provider);
  }

  void preencherCampos(CompanyProvider provider) {
    if (camposPreenchidos) {
      return;
    }

    final company = provider.company;

    if (company == null) {
      return;
    }

    nomeController.text = company.nome;

    cnpjController.text = company.cnpj ?? '';

    emailController.text = company.email ?? '';

    telefoneController.text = company.telefone ?? '';

    camposPreenchidos = true;
  }

  Future<void> salvar() async {
    if (nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Informe o nome da empresa")),
      );

      return;
    }

    final provider = context.read<CompanyProvider>();

    if (provider.company == null) {
      await provider.createCompany(
        nome: nomeController.text,

        cnpj: cnpjController.text,

        email: emailController.text,

        telefone: telefoneController.text,
      );
    } else {
      await provider.updateCompany(
        nome: nomeController.text,

        cnpj: cnpjController.text,

        email: emailController.text,

        telefone: telefoneController.text,
      );
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Empresa salva com sucesso")));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    preencherCampos(provider);

    return Scaffold(
      appBar: AppBar(title: const Text("Minha Empresa")),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  TextField(
                    controller: nomeController,

                    decoration: const InputDecoration(
                      labelText: "Nome da empresa",
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: cnpjController,

                    decoration: const InputDecoration(labelText: "CNPJ"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: emailController,

                    decoration: const InputDecoration(
                      labelText: "Email empresa",
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: telefoneController,

                    decoration: const InputDecoration(labelText: "Telefone"),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      onPressed: salvar,

                      child: Text(
                        provider.company == null
                            ? "Cadastrar Empresa"
                            : "Atualizar Empresa",
                      ),
                    ),
                  ),

                  if (provider.company != null) ...[
                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,

                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/dashboard');
                        },

                        child: const Text("Continuar"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();

    cnpjController.dispose();

    emailController.dispose();

    telefoneController.dispose();

    super.dispose();
  }
}
