import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Fetch user data from Firestore
        return await _firestoreService.getUser(userCredential.user!.uid);
      }
      return null;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  // Register with email and password
  Future<UserModel?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user document in Firestore
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          role: 'user', // Default role
          createdAt: DateTime.now(),
        );

        await _firestoreService.createUser(newUser);
        return newUser;
      }
      return null;
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      return await _firestoreService.getUser(userId);
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}
