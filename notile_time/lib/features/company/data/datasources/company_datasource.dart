import '../models/company_model.dart';

abstract class CompanyDatasource {
  Future<CompanyModel?> getCompany();

  Future<void> createCompany(CompanyModel company);

  Future<void> updateCompany(CompanyModel company);
}
