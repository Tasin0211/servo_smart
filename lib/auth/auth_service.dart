import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';
import '../utils/utils.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      logger.i('🔐 Attempting to sign in with email: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        logger.i(
          '✅ Firebase Auth successful. UID: ${userCredential.user!.uid}',
        );
        // Fetch user data from Firestore
        var userData = await _firestoreService.getUser(
          userCredential.user!.uid,
        );

        if (userData != null) {
          logger.i(
            '✅ User data loaded from Firestore. Role: ${userData.role}, Name: ${userData.name}',
          );
        } else {
          logger.w(
            '⚠️ User document NOT found in Firestore for UID: ${userCredential.user!.uid}. Creating now...',
          );
          // Create user document for legacy Firebase Auth users
          final newUser = UserModel(
            id: userCredential.user!.uid,
            email: email,
            name: userCredential.user!.displayName ?? email.split('@')[0],
            role: 'user', // Default role
            createdAt: DateTime.now(),
          );

          await _firestoreService.createUser(newUser);
          logger.i('✅ User document created in Firestore during login');
          userData = newUser;
        }
        return userData;
      }
      logger.w('⚠️ userCredential.user is null');
      return null;
    } catch (e) {
      logger.e('❌ Error signing in: $e');
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
      logger.i('📝 Attempting to register user: $email');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        logger.i(
          '✅ Firebase Auth registration successful. UID: ${userCredential.user!.uid}',
        );
        // Create user document in Firestore
        final newUser = UserModel(
          id: userCredential.user!.uid,
          email: email,
          name: name,
          role: 'user', // Default role
          createdAt: DateTime.now(),
        );

        await _firestoreService.createUser(newUser);
        logger.i('✅ User document created in Firestore');
        return newUser;
      }
      logger.w('⚠️ userCredential.user is null during registration');
      return null;
    } catch (e) {
      logger.e('❌ Error registering: $e');
      rethrow;
    }
  }

  // Get user data
  Future<UserModel?> getUserData(String userId) async {
    try {
      logger.i('📥 Fetching user data for UID: $userId');
      final userData = await _firestoreService.getUser(userId);
      if (userData != null) {
        logger.i(
          '✅ User data retrieved. Role: ${userData.role}, Name: ${userData.name}',
        );
      } else {
        logger.w('⚠️ No user data found in Firestore for UID: $userId');
      }
      return userData;
    } catch (e) {
      logger.e('❌ Error getting user data: $e');
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
