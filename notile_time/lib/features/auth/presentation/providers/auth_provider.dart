import 'package:flutter/material.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_out_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthProvider({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.forgotPasswordUseCase,
    required this.getCurrentUserUseCase,
  });

  bool _isLoading = false;
  String? _errorMessage;
  UserEntity? _user;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  UserEntity? get user => _user;

  bool get isAuthenticated => _user != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);

      _errorMessage = null;

      final result = await signUpUseCase(email: email, password: password);

      _user = result;

      notifyListeners();

      return result != null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> login({required String email, required String password}) async {
    try {
      _setLoading(true);

      _errorMessage = null;

      final result = await signInUseCase(email: email, password: password);

      _user = result;

      notifyListeners();

      return result != null;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      _setLoading(true);

      _errorMessage = null;

      await signOutUseCase();

      _user = null;

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword({required String email}) async {
    try {
      _setLoading(true);

      _errorMessage = null;

      await forgotPasswordUseCase(email: email);

      notifyListeners();

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();

      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkSession() async {
    try {
      _setLoading(true);

      _errorMessage = null;

      _user = getCurrentUserUseCase();

      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();

      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }
}
