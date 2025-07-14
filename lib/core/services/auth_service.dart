import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream of User for auth state changes
  Stream<User?> get user => _auth.authStateChanges();

  // Email & Password Sign Up
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e; // Rethrow for UI handling
    }
  }

  // Email & Password Sign In
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e; // Rethrow for UI handling
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}