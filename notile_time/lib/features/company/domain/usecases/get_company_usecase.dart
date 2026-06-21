import '../entities/company_entity.dart';

import '../repositories/company_repository.dart';

class GetCompanyUseCase {
  final CompanyRepository repository;

  GetCompanyUseCase(this.repository);

  Future<CompanyEntity?> call() {
    return repository.getCompany();
  }
}
