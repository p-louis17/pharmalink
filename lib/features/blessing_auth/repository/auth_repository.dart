import '../models/app_user.dart';

abstract class AuthRepository {
  /// Returns the currently signed-in user, or null if signed out.
  Future<AppUser?> getCurrentUser();

  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
  });

  Future<void> sendPasswordResetEmail(String email);

  Future<void> signOut();
}

/// Default implementation. Swap the TODOs below for your actual auth
/// provider (Firebase Auth, a REST backend, etc.) — the Cubit only
/// depends on the abstract [AuthRepository] contract above.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<AppUser?> getCurrentUser() async {
    // TODO: return the currently authenticated user, e.g.:
    // final firebaseUser = FirebaseAuth.instance.currentUser;
    // if (firebaseUser == null) return null;
    // final doc = await firestore.collection('users').doc(firebaseUser.uid).get();
    // return AppUser.fromJson(doc.data()!);
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    // TODO: replace with real sign-in call.
    await Future.delayed(const Duration(milliseconds: 600));
    return AppUser(
      uid: 'mock-uid',
      fullName: 'PharmaLink User',
      email: email,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<AppUser> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
    required DateTime dateOfBirth,
  }) async {
    // TODO: replace with real sign-up call.
    await Future.delayed(const Duration(milliseconds: 600));
    return AppUser(
      uid: 'mock-uid',
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      address: address,
      dateOfBirth: dateOfBirth,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    // TODO: replace with real password reset call.
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> signOut() async {
    // TODO: replace with real sign-out call.
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
