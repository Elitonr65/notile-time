import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  Future<void> _logout(BuildContext context) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    await auth.logout();

    if (!context.mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notile Time'),

        actions: [
          IconButton(
            onPressed: () => _logout(context),

            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            const Text(
              'Dashboard',

              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(auth.user?.email ?? '', style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time, size: 35),

                title: const Text('Minha Jornada'),

                subtitle: const Text('Registrar entrada, almoço e saída'),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  context.push('/jornada');
                },
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: const Icon(Icons.history, size: 35),

                title: const Text('Histórico de Jornadas'),

                subtitle: const Text('Visualizar registros anteriores'),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  context.push('/jornada/historico');
                },
              ),
            ),

            const SizedBox(height: 30),

            Card(
              child: ListTile(
                leading: const Icon(Icons.person, size: 35),

                title: const Text('Meu Perfil'),

                subtitle: const Text('Editar dados pessoais'),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  context.push('/profile');
                },
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: ListTile(
                leading: const Icon(Icons.business, size: 35),

                title: const Text('Minha Empresa'),

                subtitle: const Text('Gerenciar empresa vinculada'),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  context.push('/company');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
