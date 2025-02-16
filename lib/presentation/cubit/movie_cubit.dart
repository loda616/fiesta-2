import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/movie.dart';
import '../../domain/usecases/get_movies_usecase.dart';

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

  void resetState() {
    emit(MovieInitial());
  }
}

// Movie States
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