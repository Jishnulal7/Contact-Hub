import 'package:contact_hub/data/repo/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _loading = false;
  User? _user;
  String? _error;

  AuthProvider(this._authRepository) {
    _authRepository.authStateChanges.listen((AuthState state) {
      _user = state.session?.user;
      notifyListeners();
    });

    _user = _authRepository.currentUser;
  }

  bool get loading => _loading;
  User? get user => _user;
  Session? get session => _authRepository.currentSession;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signIn(email, password);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      await _authRepository.signUp(email, password);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _authRepository.signout();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
