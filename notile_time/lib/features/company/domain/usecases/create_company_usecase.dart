import '../entities/company_entity.dart';

import '../repositories/company_repository.dart';

class CreateCompanyUseCase {
  final CompanyRepository repository;

  CreateCompanyUseCase(this.repository);

  Future<void> call(CompanyEntity company) {
    return repository.createCompany(company);
  }
}
