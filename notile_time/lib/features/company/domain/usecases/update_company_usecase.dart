import '../entities/company_entity.dart';

import '../repositories/company_repository.dart';

class UpdateCompanyUseCase {
  final CompanyRepository repository;

  UpdateCompanyUseCase(this.repository);

  Future<void> call(CompanyEntity company) {
    return repository.updateCompany(company);
  }
}
