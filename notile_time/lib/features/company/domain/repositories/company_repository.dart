import '../entities/company_entity.dart';

abstract class CompanyRepository {
  Future<CompanyEntity?> getCompany();

  Future<void> createCompany(CompanyEntity company);

  Future<void> updateCompany(CompanyEntity company);
}
