import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../core/errors/exceptions.dart';
import '../models/movie_model.dart';

class MovieApiSource {
  final String apiKey = dotenv.env['OMDB_API_KEY'] ?? '';
  final String baseUrl = 'http://www.omdbapi.com/';
  final http.Client client;

  MovieApiSource({http.Client? client}) : client = client ?? http.Client();

  Future<MovieModel> getMovieDetails(String imdbId) async {
    final response = await client.get(
      Uri.parse('$baseUrl?i=$imdbId&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl?s=$query&apikey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['Response'] == 'True') {
        return (data['Search'] as List)
            .map((movie) => MovieModel.fromJson(movie))
            .toList();
      } else {
        return [];
      }
    } else {
      throw ServerException();
    }
  }
}