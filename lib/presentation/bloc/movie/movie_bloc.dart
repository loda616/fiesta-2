import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_movies_usecase.dart';
import '../../../domain/usecases/get_movie_details_usecase.dart';
import '../../../domain/entities/movie.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class SearchMovies extends MovieEvent {
  final String query;
  final String? genre;
  final String? year;
  final String? sortBy;

  SearchMovies(
      this.query, {
        this.genre,
        this.year,
        this.sortBy,
      });
}

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetMoviesUseCase getMovies;
  final GetMovieDetailsUseCase getMovieDetails;

  MovieBloc({
    required this.getMovies,
    required this.getMovieDetails,
  }) : super(MovieInitial()) {

    on<SearchMovies>((event, emit) async {
      emit(MovieLoading());
      final result = await getMovies(event.query);

      result.fold(
            (failure) => emit(MovieError(failure.message)),
            (movies) => emit(MovieSearchLoaded(movies)),
      );
    });

    on<GetMovieDetails>((event, emit) async {
      emit(MovieLoading());
      final result = await getMovieDetails(event.movieId);

      result.fold(
            (failure) => emit(MovieError(failure.message)),
            (movie) => emit(MovieDetailsLoaded(movie)),
      );
    });
  }
}