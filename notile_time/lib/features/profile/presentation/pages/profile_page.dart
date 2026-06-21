import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool camposPreenchidos = false;

  final nomeController = TextEditingController();

  final telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      context.read<ProfileProvider>().loadProfile();
    });
  }

  void preencherCampos(ProfileProvider provider) {
    if (camposPreenchidos) {
      return;
    }

    final profile = provider.profile;

    if (profile == null) {
      return;
    }

    nomeController.text = profile.nome;

    telefoneController.text = profile.telefone ?? '';

    camposPreenchidos = true;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    final auth = context.read<AuthProvider>();

    if (provider.profile != null) {
      preencherCampos(provider);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meu Perfil"),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  CircleAvatar(
                    radius: 45,

                    backgroundImage: provider.profile?.fotoUrl != null
                        ? NetworkImage(provider.profile!.fotoUrl!)
                        : null,

                    child: provider.profile?.fotoUrl == null
                        ? const Icon(Icons.person, size: 40)
                        : null,
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: nomeController,

                    decoration: const InputDecoration(labelText: "Nome"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: telefoneController,

                    decoration: const InputDecoration(labelText: "Telefone"),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    readOnly: true,

                    decoration: InputDecoration(
                      labelText: "Email",

                      hintText: provider.profile?.email,
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton(
                      child: const Text("Salvar"),

                      onPressed: () async {
                        await provider.updateProfile(
                          nome: nomeController.text,

                          telefone: telefoneController.text,
                        );

                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Perfil atualizado")),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    telefoneController.dispose();
    super.dispose();
  }
}
