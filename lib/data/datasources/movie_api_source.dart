import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/errors/exceptions.dart';
import '../../domain/entities/movie.dart' show Movie;
import '../models/movie_model.dart';


class MovieApiSource {
  final String apiKey = '95b349d9';
  final String baseUrl = 'http://www.omdbapi.com/';
  final http.Client client;

  MovieApiSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl?s=$query&apikey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return (data['Search'] as List)
              .map((movie) => MovieModel.fromJson(movie))
              .toList();
        }
        return [];
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }

  Future<List<Movie>> getMovieRecommendations(String movieId) async {
    try {
      final movieResponse = await client.get(
        Uri.parse('$baseUrl?i=$movieId&apikey=$apiKey'),
      );

      if (movieResponse.statusCode == 200) {
        final movieData = json.decode(movieResponse.body);
        final genre = movieData['Genre'];

        if (genre != null) {
          final recommendationsResponse = await client.get(
            Uri.parse('$baseUrl?s=${genre.split(',')[0].trim()}&type=movie&apikey=$apiKey'),
          );

          if (recommendationsResponse.statusCode == 200) {
            final data = json.decode(recommendationsResponse.body);
            if (data['Response'] == 'True') {
              return (data['Search'] as List)
                  .map((movie) => MovieModel.fromJson(movie))
                  .where((movie) => movie.imdbId != movieId)
                  .take(10)
                  .toList();
            }
          }
        }
      }
      return [];
    } catch (e) {
      throw ServerException();
    }
  }

  Future<Movie> getMovieDetails(String imdbId) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl?i=$imdbId&apikey=$apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return MovieModel.fromJson(data);
        }
        throw ServerException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}