import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

// A stream provider to listen to auth state changes.
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// A notifier for authentication actions.
final authNotifierProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user;
    });
  }

  // Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User aborted sign-in.
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('Google sign in error: $e');
      rethrow;
    }
  }

  // Email/Password Sign-In
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Email sign in error: $e');
      rethrow;
    }
  }

  // Email/Password Sign-Up
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Email sign up error: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
