import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.nome,
    required super.email,
    super.telefone,
    super.fotoUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      telefone: map['telefone'],
      fotoUrl: map['foto_url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'nome': nome, 'telefone': telefone, 'foto_url': fotoUrl};
  }
}
