import 'package:fiesta/domain/usecases/sign_in_usecase.dart' show SignInParams;
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class SignUpParams {
  final String email;
  final String password;
  final String username;

  SignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });
}

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<User> call(SignUpParams params) {
    return repository.signUp(
      params.email,
      params.password,
      params.username,
    );
  }
}
