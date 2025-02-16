part of 'movie_bloc.dart';

abstract class MovieEvent {}

class GetMovieDetails extends MovieEvent {
  final String movieId;
  GetMovieDetails(this.movieId);
}