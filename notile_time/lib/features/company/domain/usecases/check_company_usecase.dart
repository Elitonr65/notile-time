import '../repositories/company_repository.dart';

class CheckCompanyUseCase {
  final CompanyRepository repository;

  CheckCompanyUseCase(this.repository);

  Future<bool> call() async {
    final company = await repository.getCompany();

    return company != null;
  }
}
