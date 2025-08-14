import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_usecase.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchResultsLoaded extends MovieState {
  final List<Movie> movies;
  const SearchResultsLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMoviesLoaded extends MovieState {
  final List<Movie> movies;
  const PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class MovieWatchlistLoaded extends MovieState {
  final List<Movie> movies;
  final bool isWatched;
  const MovieWatchlistLoaded(this.movies, {required this.isWatched});

  @override
  List<Object> get props => [movies, isWatched];
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
            case AppStrings.rating:
              filteredMovies.sort((a, b) {
                final aRating = double.tryParse(a.imdbRating ?? '0') ?? 0;
                final bRating = double.tryParse(b.imdbRating ?? '0') ?? 0;
                return bRating.compareTo(aRating);
              });
              break;
            case AppStrings.year:
              filteredMovies.sort((a, b) => b.year.compareTo(a.year));
              break;
            case AppStrings.title:
              filteredMovies.sort((a, b) => a.title.compareTo(b.title));
              break;
          }
        }

        emit(SearchResultsLoaded(filteredMovies));
      },
    );
  }

  Future<void> loadCurrentlyWatching() async {
    emit(MovieLoading());

    try {
      // Get currently watching movies from Firestore
      final movies = await getMovies(AppStrings.currentlyWatching);
      movies.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(SearchResultsLoaded(movies)),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  Future<void> loadWatchlist({required bool isWatched}) async {
    emit(MovieLoading());

    try {
      // Get watchlist from Firestore based on isWatched status
      final movies = await getMovies(isWatched ? AppStrings.watched : AppStrings.watchlist);
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
      final movies = await getMovies(AppStrings.popular);
      movies.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(PopularMoviesLoaded(movies)),
      );
    } catch (e) {
      emit(MovieError(e.toString()));
    }
  }

  void resetState() {
    emit(MovieInitial());
  }
}