import '../models/app_user.dart';

abstract class AuthRepository {

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

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl();

  @override
  Future<AppUser?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return null;
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
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
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
