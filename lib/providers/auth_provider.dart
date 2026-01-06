import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../auth/auth_service.dart';
import '../utils/utils.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _init();
  }

  // Initialize auth state
  void _init() {
    logger.i('🚀 AuthProvider initializing...');
    _authService.authStateChanges.listen((User? firebaseUser) async {
      logger.i('🔄 Auth state changed. User: ${firebaseUser?.uid ?? "null"}');
      if (firebaseUser != null) {
        logger.i('👤 Firebase user detected, fetching user data...');
        _user = await _authService.getUserData(firebaseUser.uid);
        logger.i(
          '📊 User data loaded: ${_user?.name ?? "null"}, Role: ${_user?.role ?? "null"}',
        );
      } else {
        logger.i('🚪 No Firebase user (logged out)');
        _user = null;
      }
      _isLoading = false;
      logger.i(
        '✅ Auth state update complete. isAuthenticated: ${_user != null}',
      );
      notifyListeners();
    });
  }

  // Sign in
  Future<bool> signIn(String email, String password) async {
    try {
      logger.i('🔑 AuthProvider.signIn called for: $email');
      _isLoading = true;
      notifyListeners();

      _user = await _authService.signInWithEmailAndPassword(email, password);

      _isLoading = false;
      logger.i('✅ Sign in completed. Success: ${_user != null}');
      notifyListeners();

      return _user != null;
    } catch (e) {
      logger.e('❌ Sign in failed: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Register
  Future<bool> register(String email, String password, String name) async {
    try {
      _isLoading = true;
      notifyListeners();

      _user = await _authService.registerWithEmailAndPassword(
        email,
        password,
        name,
      );

      _isLoading = false;
      notifyListeners();

      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }
}
