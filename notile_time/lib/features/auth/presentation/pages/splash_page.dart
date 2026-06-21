import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

import '../../../company/presentation/providers/company_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => checkLogin());
  }

  Future<void> checkLogin() async {
    final auth = context.read<AuthProvider>();

    await auth.checkSession();

    if (!mounted) {
      return;
    }

    if (auth.user == null) {
      context.go('/login');

      return;
    }

    final company = context.read<CompanyProvider>();

    final hasCompany = await company.hasCompany();

    if (!mounted) {
      return;
    }

    if (hasCompany) {
      context.go('/dashboard');
    } else {
      context.go('/company');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
