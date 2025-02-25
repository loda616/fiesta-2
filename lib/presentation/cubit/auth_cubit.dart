import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart' show NoParams;
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart' show GetCurrentUserUseCase;
import '../../domain/usecases/sign_in_usecase.dart' show SignInParams, SignInUseCase;
import '../../domain/usecases/sign_out_usecase.dart' show SignOutUseCase;
import '../../domain/usecases/sign_up_usecase.dart' show SignUpParams, SignUpUseCase;
import 'auth_states.dart' show AuthError, AuthInitial, AuthLoading, AuthState, AuthSuccess;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthCubit extends Cubit<AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  // Track current user for easier access
  User? _currentUser;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(
        SignInParams(email: email, password: password),
      );
      _currentUser = user;
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(AuthLoading());
    try {
      final user = await signUpUseCase(
        SignUpParams(
          email: email,
          password: password,
          username: username,
        ),
      );
      _currentUser = user;
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
      // Add a delay before resetting to initial state
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthInitial());
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      final result = await signOutUseCase(const NoParams());
      result.fold(
              (failure) => emit(AuthError(failure.message)),
              (_) => emit(AuthInitial())
      );
    } catch (e) {
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthInitial());
    }
  }

  Future<void> checkAuthState() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase(const NoParams());
      if (user != null) {
        _currentUser = user as User;
        emit(AuthSuccess(_currentUser!));
      } else {
        _currentUser = null;
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthInitial());
    }
  }

  Future<void> updateUsername(String newUsername) async {
    if (_currentUser == null) {
      emit(AuthError('No user is logged in'));
      return;
    }

    emit(AuthLoading());
    try {
      // Update username in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.id)
          .update({'username': newUsername});

      // Update local user object
      _currentUser = User(
        id: _currentUser!.id,
        email: _currentUser!.email,
        username: newUsername,
        createdAt: _currentUser!.createdAt,
      );

      emit(AuthSuccess(_currentUser!));
    } catch (e) {
      emit(AuthError('Failed to update username: ${e.toString()}'));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(AuthLoading());
    try {
      // Send password reset email using Firebase Auth
      await firebase_auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      // If current user exists, emit success, otherwise emit initial state
      if (_currentUser != null) {
        emit(AuthSuccess(_currentUser!));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError('Failed to send password reset email: ${e.toString()}'));
    }
  }
}