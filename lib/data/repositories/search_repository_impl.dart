import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/movie.dart';
import '../../domain/repositories/search_epository.dart' show SearchRepository;
import '../datasources/Watchmode/watchmode_api_client.dart';
import '../datasources/Watchmode/rate_limiter.dart';
import '../models/movies/movie_model.dart';



class SearchRepositoryImpl implements SearchRepository {
  final WatchmodeApiClient _client;
  final RateLimiter _rateLimiter;
  final String apiKey;

  SearchRepositoryImpl(
      this._client,
      this._rateLimiter,
      this.apiKey,
      );

  @override
  Future<Either<Failure, List<Movie>>> searchContent(
      String query, {
        String searchField = 'name',
        String? contentType,
      }) async {
    try {
      if (!_rateLimiter.canMakeRequest()) {
        final delay = _rateLimiter.timeUntilNextAvailable();
        await Future.delayed(delay);
      }

      _rateLimiter.registerRequest();

      final response = await _client.search(
        apiKey: apiKey,
        searchField: searchField,
        searchValue: query,
        types: contentType,
      );

      if (response.titleResults != null && response.titleResults!.isNotEmpty) {
        final titles = response.titleResults!;
        final List<Movie> detailedMovies = [];

        for (var title in titles.take(10)) { // Limit to top 10 for performance
          try {
            // Get detailed information including poster
            final detailsResponse = await _client.getTitleDetails(
              titleId: title.id.toString(),
              apiKey: apiKey,
            );

            detailedMovies.add(MovieModel.fromWatchmodeDetailJson(detailsResponse));
          } catch (e) {
            // If details fail, add basic info
            detailedMovies.add(MovieModel.fromWatchmodeJson(title));
          }
        }

        return Right(detailedMovies);
      }

      return const Right([]);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure('Network error: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Failed to search: ${e.toString()}'));
    }
  }
}