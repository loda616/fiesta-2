import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import '../../core/usecases/usecase.dart';


class GetCurrentUserUseCase extends UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<User?> call(NoParams params) async {
    return repository.getCurrentUser();
  }
}
