class ProfileEntity {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? fotoUrl;

  ProfileEntity({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoUrl,
  });
}
