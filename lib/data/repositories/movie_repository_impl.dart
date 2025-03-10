import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../core/errors/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/Watchmode/watchmode_api_source.dart';

@LazySingleton(as: MovieRepository)
class MovieRepositoryImpl implements MovieRepository {
  final WatchmodeApiSource apiSource;

  MovieRepositoryImpl(this.apiSource);

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final movies = await apiSource.searchMovies(query);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(String movieId) async {
    try {
      // Check if we have a Watchmode ID, otherwise try to get one
      String watchmodeId = movieId;

      // If the ID looks like an IMDB ID (starts with 'tt'), try to convert it
      if (movieId.startsWith('tt')) {
        final id = await apiSource.getWatchmodeIdFromImdbId(movieId);
        if (id != null) {
          watchmodeId = id;
        } else {
          // If we can't get a Watchmode ID, return an empty list
          return const Right([]);
        }
      }

      final movies = await apiSource.getMovieRecommendations(watchmodeId);
      return Right(movies);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie recommendations: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, Movie>> getMovieDetails(String imdbId) async {
    try {
      // Check if this is already a Watchmode ID or an IMDB ID
      String watchmodeId = imdbId;

      // If the ID looks like an IMDB ID (starts with 'tt'), try to convert it
      if (imdbId.startsWith('tt')) {
        final id = await apiSource.getWatchmodeIdFromImdbId(imdbId);
        if (id != null) {
          watchmodeId = id;
        } else {
          return Left(ServerFailure('Movie not found'));
        }
      }

      final movie = await apiSource.getMovieDetails(watchmodeId);
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie details: ${e.toString()}'));
    }
  }
}