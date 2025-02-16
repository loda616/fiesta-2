part of 'movie_bloc.dart';

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
class MovieDetailsLoaded extends MovieState {
  final Movie movie;
  MovieDetailsLoaded(this.movie);
}