import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_api_source.dart';



class MovieRepositoryImpl implements MovieRepository {
  final MovieApiSource movieApiSource;

  MovieRepositoryImpl(this.movieApiSource);

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await movieApiSource.searchMovies(query);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Failed to search movies'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(String movieId) async {
    try {
      final movies = await movieApiSource.getMovieRecommendations(movieId);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie recommendations: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(String imdbId) async {
    try {
      final movie = await movieApiSource.getMovieDetails(imdbId);
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie details'));
    }
  }
}
