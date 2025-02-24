import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';

import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/movie.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> searchMovies(String query);
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(String movieId);
  Future<Either<Failure, Movie>> getMovieDetails(String imdbId);
}