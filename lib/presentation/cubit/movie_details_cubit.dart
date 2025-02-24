import 'package:fiesta/domain/usecases/get_movie_recommendations_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movie_details_usecase.dart';

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

  MovieDetailsCubit({
    required this.getMovieDetails,
    required this.getMovieRecommendations,
  }) : super(MovieDetailsInitial());

  Future<void> loadMovieDetails(String movieId) async {
    emit(MovieDetailsLoading());

    try {
      final movieResult = await getMovieDetails(movieId);
      final recommendationsResult = await getMovieRecommendations(movieId);

      movieResult.fold(
            (failure) => emit(MovieDetailsError(failure.message)),
            (movie) {
          recommendationsResult.fold(
                (failure) => emit(MovieDetailsError(failure.message)),
                (recommendations) => emit(MovieDetailsLoaded(
              movie,
              recommendations,
              false, // TODO: Check if movie is in watchlist
            )),
          );
        },
      );
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }
}