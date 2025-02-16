//import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/entities/user.dart';
// import '../../../domain/usecases/sign_in_usecase.dart';
// import '../../../domain/usecases/sign_up_usecase.dart';
// import '../../core/usecases/usecase.dart';
// import '../../domain/usecases/get_current_user_usecase.dart';
// import '../../domain/usecases/sign_out_usecase.dart';
//
// part 'auth_event.dart';
// part 'auth_state.dart';
//
//
// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final SignInUseCase signInUseCase;
//   final SignUpUseCase signUpUseCase;
//   final SignOutUseCase signOutUseCase;
//   final GetCurrentUserUseCase getCurrentUserUseCase;
//
//   AuthBloc({
//     required this.signInUseCase,
//     required this.signUpUseCase,
//     required this.signOutUseCase,
//     required this.getCurrentUserUseCase,
//   }) : super(AuthInitial()) {
//
//     on<SignInRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         final user = await signInUseCase(
//           SignInParams(
//             email: event.email,
//             password: event.password,
//           ),
//         );
//         emit(AuthSuccess(user));
//       } catch (e) {
//         emit(AuthError(e.toString()));
//       }
//     });
//
//     on<SignUpRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         final user = await signUpUseCase(
//           SignUpParams(
//             email: event.email,
//             password: event.password,
//             username: event.username,
//           ),
//         );
//         emit(AuthSuccess(user));
//       } catch (e) {
//         emit(AuthError(e.toString()));
//       }
//     });
//
//     on<SignOutRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         await signOutUseCase(NoParams());
//         emit(AuthInitial());
//       } catch (e) {
//         emit(AuthError(e.toString()));
//       }
//     });
//
//     on<AuthCheckRequested>((event, emit) async {
//       emit(AuthLoading());
//       try {
//         final user = await getCurrentUserUseCase(NoParams());
//         if (user != null) {
//           emit(AuthSuccess(user));
//         } else {
//           emit(AuthInitial());
//         }
//       } catch (e) {
//         emit(AuthError(e.toString()));
//       }
//     });
//   }
// }