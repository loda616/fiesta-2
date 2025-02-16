import 'package:dartz/dartz.dart';
import '../entities/movie.dart';
import '../../core/errors/failures.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, void>> addToWatchlist(Movie movie);
  Future<Either<Failure, void>> removeFromWatchlist(String movieId);
  Future<Either<Failure, void>> markAsWatched(String movieId, bool watched);
  Stream<Either<Failure, List<Movie>>> watchlistStream();
}