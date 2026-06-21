import '../../domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.id,

    required super.nome,

    super.cnpj,

    super.email,

    super.telefone,

    required super.criadoPor,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map) {
    return CompanyModel(
      id: map['id'],

      nome: map['nome'] ?? '',

      cnpj: map['cnpj'],

      email: map['email'],

      telefone: map['telefone'],

      criadoPor: map['criado_por'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,

      'cnpj': cnpj,

      'email': email,

      'telefone': telefone,

      'criado_por': criadoPor,
    };
  }
}
