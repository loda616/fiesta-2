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
      final result = await signInUseCase(
        SignInParams(email: email, password: password),
      );

      result.fold(
              (failure) => emit(AuthError(failure.message)),
              (user) {
            _currentUser = user;
            emit(AuthSuccess(user));
          }
      );
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
      final result = await signUpUseCase(
        SignUpParams(
          email: email,
          password: password,
          username: username,
        ),
      );

      result.fold(
              (failure) => emit(AuthError(failure.message)),
              (user) {
            _currentUser = user;
            emit(AuthSuccess(user));
          }
      );
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
      final result = await getCurrentUserUseCase(const NoParams());
      result.fold(
              (failure) => emit(AuthInitial()),
              (user) {
            if (user != null) {
              _currentUser = user;
              emit(AuthSuccess(user));
            } else {
              emit(AuthInitial());
            }
          }
      );
    } catch (e) {
      emit(AuthError(e.toString()));
      await Future.delayed(const Duration(seconds: 2));
      emit(AuthInitial());
    }
  }
}