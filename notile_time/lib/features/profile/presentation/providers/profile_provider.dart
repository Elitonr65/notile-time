import 'package:flutter/material.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  bool isLoading = false;

  String? errorMessage;

  ProfileEntity? profile;

  Future<void> loadProfile() async {
    try {
      isLoading = true;
      notifyListeners();

      profile = await getProfileUseCase();

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String nome,
    String? telefone,
    String? fotoUrl,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      await updateProfileUseCase(
        nome: nome,
        telefone: telefone,
        fotoUrl: fotoUrl,
      );

      await loadProfile();

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}
