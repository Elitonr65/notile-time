class CompanyEntity {
  final String id;

  final String nome;

  final String? cnpj;

  final String? email;

  final String? telefone;

  final String criadoPor;

  CompanyEntity({
    required this.id,

    required this.nome,

    this.cnpj,

    this.email,

    this.telefone,

    required this.criadoPor,
  });
}
