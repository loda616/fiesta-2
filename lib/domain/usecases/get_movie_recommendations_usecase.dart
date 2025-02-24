import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieRecommendationsUseCase implements UseCase<List<Movie>, String> {
  final MovieRepository repository;

  GetMovieRecommendationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(String movieId) async {
    return await repository.getMovieRecommendations(movieId);
  }
}

