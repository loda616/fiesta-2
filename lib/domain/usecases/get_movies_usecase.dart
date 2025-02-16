import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/movie_repository.dart';
import '../entities/movie.dart';

class GetMoviesUseCase {
  final MovieRepository repository;

  GetMoviesUseCase(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) {
    return repository.searchMovies(query);
  }
}