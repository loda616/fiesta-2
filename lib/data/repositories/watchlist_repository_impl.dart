import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_firebase_source.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistFirebaseSource _firebaseSource;

  WatchlistRepositoryImpl(this._firebaseSource);

  @override
  Future<Either<Failure, void>> addToWatchlist(Movie movie) async {
    try {
      await _firebaseSource.addToWatchlist(movie);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to add to watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatchlist(String movieId) async {
    try {
      await _firebaseSource.removeFromWatchlist(movieId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to remove from watchlist: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsWatched(String movieId, bool watched) async {
    try {
      await _firebaseSource.markAsWatched(movieId, watched);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update watch status: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<Movie>>> watchlistStream() {
    return _firebaseSource.getWatchlist().map(
          (movies) => Right<Failure, List<Movie>>(movies),
    ).handleError(
          (error) => Left<Failure, List<Movie>>(
        ServerFailure('Failed to get watchlist: ${error.toString()}'),
      ),
    );
  }
}
