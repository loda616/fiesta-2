import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart' show NoParams;
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_current_user_usecase.dart' show GetCurrentUserUseCase;
import '../../domain/usecases/sign_in_usecase.dart' show SignInParams, SignInUseCase;
import '../../domain/usecases/sign_out_usecase.dart' show SignOutUseCase;
import '../../domain/usecases/sign_up_usecase.dart' show SignUpParams, SignUpUseCase;

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

  Future<void> checkAuthState() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase(const NoParams());
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await signInUseCase(
        SignInParams(email: email, password: password),
      );
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
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await signOutUseCase(const NoParams());
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

// Auth States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}