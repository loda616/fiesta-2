import 'dart:async';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/errors/exceptions.dart';
import '../../../domain/entities/movie.dart';
import '../../models/movies/movie_model.dart';
import 'rate_limiter.dart';
import 'watchmode_api_client.dart';

@injectable
class WatchmodeApiSource {
  final String apiKey;
  final WatchmodeApiClient _client;
  final RateLimiter _rateLimiter;

  WatchmodeApiSource(
      this._client,
      this._rateLimiter,
      @factoryParam this.apiKey,
      );

  // Helper method to handle rate limiting
  Future<T> _makeRateLimitedRequest<T>(Future<T> Function() request) async {
    if (!_rateLimiter.canMakeRequest()) {
      final delay = _rateLimiter.timeUntilNextAvailable();
      await Future.delayed(delay);
    }

    _rateLimiter.registerRequest();
    return await request();
  }

  Future<List<Movie>> searchMovies(String query) async {
    return _makeRateLimitedRequest(() async {
      try {
        final response = await _client.search(
          apiKey: apiKey,
          searchField: 'name',
          searchValue: query,
        );

        if (response.titleResults != null && response.titleResults!.isNotEmpty) {
          final titles = response.titleResults!;
          // Get details for the first 10 results to get more information
          final List<Movie> detailedMovies = [];

          for (var title in titles.take(10)) {
            try {
              // Get detailed information for each title
              final detailsResponse = await _client.getTitleDetails(
                titleId: title.id.toString(),
                apiKey: apiKey,
                appendToResponse: 'sources',
              );

              detailedMovies.add(MovieModel.fromWatchmodeDetailJson(detailsResponse));
            } catch (e) {
              // If we can't get details, still include basic info
              detailedMovies.add(MovieModel.fromWatchmodeJson(title));
            }
          }

          return detailedMovies;
        }
        return [];
      } on DioException catch (e) {
        throw ServerException(message: e.message ?? 'Failed to search movies');
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    });
  }

  Future<Movie> getMovieDetails(String watchmodeId) async {
    return _makeRateLimitedRequest(() async {
      try {
        final response = await _client.getTitleDetails(
          titleId: watchmodeId,
          apiKey: apiKey,
          appendToResponse: 'sources',
        );

        return MovieModel.fromWatchmodeDetailJson(response);
      } on DioException catch (e) {
        throw ServerException(message: e.message ?? 'Failed to get movie details');
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    });
  }

  Future<List<Movie>> getMovieRecommendations(String watchmodeId) async {
    try {
      // Get title details to access similar_titles
      final details = await _client.getTitleDetails(
        titleId: watchmodeId,
        apiKey: apiKey,
      );

      if (details.similarTitles != null && details.similarTitles!.isNotEmpty) {
        // Take only the first 5 recommendations to limit API calls
        final similarIds = details.similarTitles!.take(5).toList();

        List<Movie> recommendations = [];
        // Fetch details for each similar title
        for (var id in similarIds) {
          try {
            final recommendationResponse = await _client.getTitleDetails(
              titleId: id.toString(),
              apiKey: apiKey,
            );

            recommendations.add(MovieModel.fromWatchmodeDetailJson(recommendationResponse));
          } catch (e) {
            // Skip if one recommendation fails
            continue;
          }
        }

        return recommendations;
      }
      return [];
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get recommendations');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
  // Helper method to convert IMDB ID to Watchmode ID
  Future<String?> getWatchmodeIdFromImdbId(String imdbId) async {
    try {
      final response = await _client.search(
        apiKey: apiKey,
        searchField: 'imdb_id',
        searchValue: imdbId,
      );

      if (response.titleResults != null && response.titleResults!.isNotEmpty) {
        return response.titleResults![0].id.toString();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Get TV show seasons
  Future<List<dynamic>> getTvShowSeasons(String watchmodeId) async {
    try {
      final response = await _client.getTitleSeasons(
        titleId: watchmodeId,
        apiKey: apiKey,
      );

      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get TV show seasons');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  Future<List<StreamingSource>> getTitleSources(String watchmodeId) async {
    return _makeRateLimitedRequest(() async {
      try {
        final response = await _client.getTitleSources(
          titleId: watchmodeId,
          apiKey: apiKey,
        );

        return response.map((source) => StreamingSource(
          id: source.sourceId.toString(),
          name: source.name,
          type: source.type,
          region: source.region,
          webUrl: source.webUrl,
          format: source.format,
          price: source.price?.toString(),
        )).toList();
      } on DioException catch (e) {
        throw ServerException(message: e.message ?? 'Failed to get title sources');
      } catch (e) {
        throw ServerException(message: e.toString());
      }
    });
  }
  // Get TV show episodes
  Future<List<dynamic>> getTvShowEpisodes(String watchmodeId) async {
    try {
      final response = await _client.getTitleEpisodes(
        titleId: watchmodeId,
        apiKey: apiKey,
      );

      return response;
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get TV show episodes');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}