// lib/data/models/movie_model.dart
import '../../domain/entities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required String imdbId,
    required String title,
    required String year,
    required String poster,
    String? plot,
    String? runtime,
    String? genre,
    String? director,
    String? actors,
    String? imdbRating,
    bool isInWatchlist = false,
  }) : super(
    imdbId: imdbId,
    title: title,
    year: year,
    poster: poster,
    plot: plot,
    runtime: runtime,
    genre: genre,
    director: director,
    actors: actors,
    imdbRating: imdbRating,
    isInWatchlist: isInWatchlist,
  );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      imdbId: json['imdbID'] ?? '',
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      poster: json['Poster'] != 'N/A' ? json['Poster'] : '',
      plot: json['Plot'],
      runtime: json['Runtime'],
      genre: json['Genre'],
      director: json['Director'],
      actors: json['Actors'],
      imdbRating: json['imdbRating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imdbID': imdbId,
      'Title': title,
      'Year': year,
      'Poster': poster,
      'Plot': plot,
      'Runtime': runtime,
      'Genre': genre,
      'Director': director,
      'Actors': actors,
      'imdbRating': imdbRating,
    };
  }
}