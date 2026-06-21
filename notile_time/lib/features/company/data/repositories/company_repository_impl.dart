import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_datasource.dart';
import '../models/company_model.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyDatasource datasource;

  CompanyRepositoryImpl(this.datasource);

  @override
  Future<CompanyEntity?> getCompany() {
    return datasource.getCompany();
  }

  @override
  Future<void> createCompany(CompanyEntity company) {
    return datasource.createCompany(
      CompanyModel(
        id: '',
        nome: company.nome,
        cnpj: company.cnpj,
        email: company.email,
        telefone: company.telefone,
        criadoPor: company.criadoPor,
      ),
    );
  }

  @override
  Future<void> updateCompany(CompanyEntity company) {
    return datasource.updateCompany(
      CompanyModel(
        id: company.id,
        nome: company.nome,
        cnpj: company.cnpj,
        email: company.email,
        telefone: company.telefone,
        criadoPor: company.criadoPor,
      ),
    );
  }
}
