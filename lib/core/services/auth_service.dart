import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// One place for all Firebase Auth + Firestore user calls, so screens
// don't talk to Firebase directly. Every method returns null on success,
// or an error message you can show the person in a SnackBar.
class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String?> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed. Please try again.';
    }
  }

  // Creates the auth account, then saves the extra profile fields
  // (name, address, phone, dob) in a "users" collection in Firestore,
  // keyed by the new account's uid.
  Future<String?> register({
    required String name,
    required String address,
    required String email,
    required String phone,
    required DateTime dob,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'name': name.trim(),
        'address': address.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'dob': dob.toIso8601String(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Registration failed. Please try again.';
    }
  }

  Future<void> signOut() => _auth.signOut();

  User? get currentUser => _auth.currentUser;

  // Fires whenever the person logs in or out, so screens can rebuild
  // (e.g. swap the "Login" button for a profile icon) without a restart.
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
