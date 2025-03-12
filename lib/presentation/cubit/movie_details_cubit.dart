import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';
import '../../domain/usecases/get_movie_recommendations_usecase.dart';

abstract class MovieDetailsState {}

class MovieDetailsInitial extends MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {
  final String message;
  MovieDetailsError(this.message);
}

class MovieDetailsLoaded extends MovieDetailsState {
  final Movie movie;
  final List<Movie> recommendations;
  final bool isInWatchlist;
  MovieDetailsLoaded(this.movie, this.recommendations, this.isInWatchlist);
}

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final GetMovieDetailsUseCase getMovieDetails;
  final GetMovieRecommendationsUseCase getMovieRecommendations;

  // To keep track of the current movie
  Movie? _currentMovie;
  bool _isInWatchlist = false;

  MovieDetailsCubit({
    required this.getMovieDetails,
    required this.getMovieRecommendations,
  }) : super(MovieDetailsInitial());

  Future<void> loadMovieDetails(String movieId) async {
    emit(MovieDetailsLoading());

    try {
      final movieResult = await getMovieDetails(movieId);

      movieResult.fold(
            (failure) => emit(MovieDetailsError(failure.message)),
            (movie) async {
          _currentMovie = movie;

          // Check if movie is in watchlist (this could come from a repository)
          _isInWatchlist = movie.isInWatchlist;

          // Get recommendations
          final recommendationsResult = await getMovieRecommendations(
              movie.watchmodeId ?? movie.imdbId // Prefer Watchmode ID if available
          );

          recommendationsResult.fold(
                (failure) {
              // If we have the movie but recommendations failed, still show the movie
              // with empty recommendations
              emit(MovieDetailsLoaded(movie, [], _isInWatchlist));
            },
                (recommendations) {
              emit(MovieDetailsLoaded(movie, recommendations, _isInWatchlist));
            },
          );
        },
      );
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }

  // Toggle watchlist status
  Future<void> toggleWatchlist() async {
    if (_currentMovie == null) return;

    // In a real implementation, this would call a repository to update the database
    _isInWatchlist = !_isInWatchlist;

    // Emit new state with updated watchlist status
    if (state is MovieDetailsLoaded) {
      final currentState = state as MovieDetailsLoaded;
      emit(MovieDetailsLoaded(
          currentState.movie,
          currentState.recommendations,
          _isInWatchlist
      ));
    }
  }

  // Get cast and crew information
  Future<void> loadCastAndCrew(String movieId) async {
    // This would typically call a repository method to get cast and crew
    // For Watchmode API, this would use the /title/{title_id}/cast-crew/ endpoint
    // Not implemented in this update
  }
}