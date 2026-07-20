import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthState.initial());

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _repository.getCurrentUser();
      emit(state.copyWith(
        status: user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
      ));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _repository.signIn(email: email, password: password);
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Incorrect email or password.',
      ));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _repository.signUp(
        fullName: fullName,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        address: address,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Could not create your account. Please try again.',
      ));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _repository.sendPasswordResetEmail(email);
      emit(state.copyWith(status: AuthStatus.passwordResetSent));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: 'Could not send reset email. Please try again.',
      ));
    }
  }

  Future<void> logout() async {
    await _repository.signOut();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}