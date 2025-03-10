import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_usecase.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
}

class MovieSearchLoaded extends MovieState {
  final List<Movie> movies;
  MovieSearchLoaded(this.movies);
}

class MovieWatchlistLoaded extends MovieState {
  final List<Movie> movies;
  final bool isWatched;
  MovieWatchlistLoaded(this.movies, {required this.isWatched});
}

class MovieCubit extends Cubit<MovieState> {
  final GetMoviesUseCase getMovies;

  MovieCubit({required this.getMovies}) : super(MovieInitial());

  Future<void> searchMovies(String searchQuery, {
    String? genre,
    String? year,
    String? sortBy,
  }) async {
    emit(MovieLoading());

    final result = await getMovies(searchQuery);

    result.fold(
          (failure) => emit(MovieError(failure.message)),
          (movies) {
        var filteredMovies = movies;

        if (genre != null && genre != 'All') {
          filteredMovies = filteredMovies
              .where((movie) => movie.genre?.contains(genre) ?? false)
              .toList();
        }

        if (year != null && year != 'All') {
          filteredMovies = filteredMovies
              .where((movie) => movie.year == year)
              .toList();
        }

        if (sortBy != null) {
          switch (sortBy) {
            case 'Rating':
              filteredMovies.sort((a, b) =>
                  (b.imdbRating ?? '0').compareTo(a.imdbRating ?? '0'));
              break;
            case 'Year':
              filteredMovies.sort((a, b) => b.year.compareTo(a.year));
              break;
            case 'Title':
              filteredMovies.sort((a, b) => a.title.compareTo(b.title));
              break;
          }
        }

        emit(MovieSearchLoaded(filteredMovies));
      },
    );
  }

  Future<void> loadCurrentlyWatching() async {
    emit(MovieLoading());

    try {
      // Get currently watching movies from Firestore
      final movies = await getMovies('currentlyWatching');
      movies.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(MovieSearchLoaded(movies)),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> loadWatchlist({required bool isWatched}) async {
    emit(MovieLoading());

    try {
      // Get watchlist from Firestore based on isWatched status
      final movies = await getMovies(isWatched ? 'watched' : 'watchlist');
      movies.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(MovieWatchlistLoaded(movies, isWatched: isWatched)),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> loadPopularMovies() async {
    emit(MovieLoading());

    try {
      final movies = await getMovies('popular');
      movies.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(MovieSearchLoaded(movies)),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void resetState() {
    emit(MovieInitial());
  }
}