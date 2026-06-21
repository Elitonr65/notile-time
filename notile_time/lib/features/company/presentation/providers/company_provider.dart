import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/company_entity.dart';

import '../../domain/usecases/get_company_usecase.dart';
import '../../domain/usecases/create_company_usecase.dart';
import '../../domain/usecases/update_company_usecase.dart';
import '../../domain/usecases/check_company_usecase.dart';

class CompanyProvider extends ChangeNotifier {
  final GetCompanyUseCase getCompanyUseCase;

  final CreateCompanyUseCase createCompanyUseCase;

  final UpdateCompanyUseCase updateCompanyUseCase;

  final CheckCompanyUseCase checkCompanyUseCase;

  CompanyProvider({
    required this.getCompanyUseCase,

    required this.createCompanyUseCase,

    required this.updateCompanyUseCase,

    required this.checkCompanyUseCase,
  });

  bool isLoading = false;

  String? errorMessage;

  CompanyEntity? company;

  Future<void> loadCompany() async {
    try {
      isLoading = true;

      notifyListeners();

      company = await getCompanyUseCase();

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<bool> hasCompany() async {
    return checkCompanyUseCase();
  }

  Future<void> createCompany({
    required String nome,

    String? cnpj,

    String? email,

    String? telefone,
  }) async {
    try {
      isLoading = true;

      notifyListeners();

      final userId = Supabase.instance.client.auth.currentUser!.id;

      final company = CompanyEntity(
        id: '',

        nome: nome,

        cnpj: cnpj,

        email: email,

        telefone: telefone,

        criadoPor: userId,
      );

      await createCompanyUseCase(company);

      await loadCompany();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }

  Future<void> updateCompany({
    required String nome,

    String? cnpj,

    String? email,

    String? telefone,
  }) async {
    if (company == null) {
      return;
    }

    try {
      isLoading = true;

      notifyListeners();

      final updated = CompanyEntity(
        id: company!.id,

        nome: nome,

        cnpj: cnpj,

        email: email,

        telefone: telefone,

        criadoPor: company!.criadoPor,
      );

      await updateCompanyUseCase(updated);

      await loadCompany();
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;

    notifyListeners();
  }
}
