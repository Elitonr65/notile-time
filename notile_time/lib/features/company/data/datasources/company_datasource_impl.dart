import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/company_model.dart';

import 'company_datasource.dart';

class CompanyDatasourceImpl implements CompanyDatasource {
  final SupabaseClient client;

  CompanyDatasourceImpl(this.client);

  @override
  Future<CompanyModel?> getCompany() async {
    final user = client.auth.currentUser!;

    final response = await client
        .from('empresas')
        .select()
        .eq('criado_por', user.id)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return CompanyModel.fromMap(response);
  }

  @override
  Future<void> createCompany(CompanyModel company) async {
    await client.from('empresas').insert(company.toMap());
  }

  @override
  Future<void> updateCompany(CompanyModel company) async {
    await client.from('empresas').update(company.toMap()).eq('id', company.id);
  }
}
