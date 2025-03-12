import 'package:dartz/dartz.dart' show Either, Left, Right;
import '../../core/errors/failures.dart' show Failure, ServerFailure;
import '../../core/usecases/usecase.dart';
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

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    try {
      final user = await repository.signUp(
          params.email,
          params.password,
          params.username
      );
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
