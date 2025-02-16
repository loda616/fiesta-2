import '../repositories/auth_repository.dart';
import '../../core/usecases/usecase.dart';

class SignOutUseCase extends UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) async {
    return repository.signOut();
  }
}
