import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetailsUseCase {
  final MovieRepository repository;

  GetMovieDetailsUseCase(this.repository);

  Future<Either<Failure, Movie>> call(String movieId) {
    return repository.getMovieDetails(movieId);
  }
}