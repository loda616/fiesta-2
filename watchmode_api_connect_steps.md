Step 1: Set up Watchmode API Key and Environment

Sign up for a Watchmode API key if you haven't already
Store the API key securely in your app (similar to how you did with OMDb)
Update your environment variables or configuration files to use Watchmode's base URL: https://api.watchmode.com/v1/

Step 2: Update API Client Layer

Create a new API client service specifically for Watchmode:

dartCopyclass WatchmodeApiSource {
final String apiKey;
final String baseUrl = 'https://api.watchmode.com/v1/';
final http.Client client;

WatchmodeApiSource({
required this.apiKey,
http.Client? client
}) : client = client ?? http.Client();

// Create methods for each endpoint you need
}

Implement methods to match your current functionality:

dartCopyFuture<List<Movie>> searchMovies(String query) async {
try {
final response = await client.get(
Uri.parse('$baseUrl/search/?apiKey=$apiKey&search_field=name&search_value=$query'),
);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['title_results'] as List)
          .map((movie) => MovieModel.fromWatchmodeJson(movie))
          .toList();
    } else {
      throw ServerException();
    }
} catch (e) {
throw ServerException();
}
}

Future<Movie> getMovieDetails(String id) async {
try {
final response = await client.get(
Uri.parse('$baseUrl/title/$id/details/?apiKey=$apiKey&append_to_response=sources'),
);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return MovieModel.fromWatchmodeJson(data);
    } else {
      throw ServerException();
    }
} catch (e) {
throw ServerException();
}
}
Step 3: Update Model Classes

Modify your MovieModel class to handle Watchmode JSON structure:

dartCopyfactory MovieModel.fromWatchmodeJson(Map<String, dynamic> json) {
return MovieModel(
imdbId: json['imdb_id'] ?? '',
title: json['title'] ?? json['name'] ?? '',
year: json['year']?.toString() ?? '',
poster: json['poster'] ?? json['image_url'] ?? '',
plot: json['plot_overview'],
runtime: json['runtime_minutes']?.toString() != null ?
"${json['runtime_minutes']} min" : null,
genre: json['genre_names']?.join(', '),
director: null, // Will need to be fetched separately with Watchmode
actors: null, // Will need to be fetched separately with Watchmode
imdbRating: json['user_rating']?.toString(),
);
}

Create additional models or update existing ones for Watchmode-specific features:

dartCopyclass WatchmodeSource {
final int sourceId;
final String name;
final String type; // sub, buy, etc
final String? regionCode;
final String? webUrl;

WatchmodeSource({
required this.sourceId,
required this.name,
required this.type,
this.regionCode,
this.webUrl,
});

factory WatchmodeSource.fromJson(Map<String, dynamic> json) {
return WatchmodeSource(
sourceId: json['source_id'],
name: json['name'],
type: json['type'],
regionCode: json['region'],
webUrl: json['web_url'],
);
}
}
Step 4: Update Repository Implementation

Modify your existing repository implementation to use the new Watchmode API:

dartCopyclass MovieRepositoryImpl implements MovieRepository {
final WatchmodeApiSource watchmodeApiSource;

MovieRepositoryImpl(this.watchmodeApiSource);

@override
Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
try {
final movies = await watchmodeApiSource.searchMovies(query);
return Right(movies);
} catch (e) {
return Left(ServerFailure('Failed to search movies'));
}
}

@override
Future<Either<Failure, Movie>> getMovieDetails(String imdbId) async {
try {
// First we need to find the Watchmode ID using the IMDb ID
final searchResponse = await watchmodeApiSource.client.get(
Uri.parse('${watchmodeApiSource.baseUrl}/search/?apiKey=${watchmodeApiSource.apiKey}&search_field=imdb_id&search_value=$imdbId'),
);

      final searchData = json.decode(searchResponse.body);
      if (searchData['title_results'].isEmpty) {
        return Left(ServerFailure('Movie not found'));
      }
      
      final watchmodeId = searchData['title_results'][0]['id'];
      final movie = await watchmodeApiSource.getMovieDetails(watchmodeId.toString());
      return Right(movie);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie details'));
    }
}

@override
Future<Either<Failure, List<Movie>>> getMovieRecommendations(String movieId) async {
try {
// Get similar titles using Watchmode
final detailsResponse = await watchmodeApiSource.client.get(
Uri.parse('${watchmodeApiSource.baseUrl}/title/$movieId/details/?apiKey=${watchmodeApiSource.apiKey}'),
);

      final detailsData = json.decode(detailsResponse.body);
      final similarIds = detailsData['similar_titles'] as List<dynamic>;
      
      List<Movie> recommendations = [];
      // Get details for each similar title (consider limiting to top 5-10)
      for (var id in similarIds.take(5)) {
        try {
          final movie = await watchmodeApiSource.getMovieDetails(id.toString());
          recommendations.add(movie);
        } catch (e) {
          // Skip if one recommendation fails
          continue;
        }
      }
      
      return Right(recommendations);
    } catch (e) {
      return Left(ServerFailure('Failed to get movie recommendations: ${e.toString()}'));
    }
}
}
Step 5: Handle Additional Watchmode-Specific Features

For TV shows, implement seasons and episodes functionality:

dartCopyFuture<List<Season>> getTvShowSeasons(String watchmodeId) async {
try {
final response = await client.get(
Uri.parse('$baseUrl/title/$watchmodeId/seasons/?apiKey=$apiKey'),
);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((season) => Season.fromJson(season)).toList();
    } else {
      throw ServerException();
    }
} catch (e) {
throw ServerException();
}
}

Future<List<Episode>> getTvShowEpisodes(String watchmodeId) async {
try {
final response = await client.get(
Uri.parse('$baseUrl/title/$watchmodeId/episodes/?apiKey=$apiKey'),
);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((episode) => Episode.fromJson(episode)).toList();
    } else {
      throw ServerException();
    }
} catch (e) {
throw ServerException();
}
}

Create the corresponding models:

dartCopyclass Season {
final int id;
final String name;
final int? number;
final String? posterUrl;
final String? overview;
final String? airDate;
final int? episodeCount;

Season({
required this.id,
required this.name,
this.number,
this.posterUrl,
this.overview,
this.airDate,
this.episodeCount,
});

factory Season.fromJson(Map<String, dynamic> json) {
return Season(
id: json['id'],
name: json['name'],
number: json['number'],
posterUrl: json['poster_url'],
overview: json['overview'],
airDate: json['air_date'],
episodeCount: json['episode_count'],
);
}
}

class Episode {
final int id;
final String name;
final int episodeNumber;
final int seasonNumber;
final int? seasonId;
final String? thumbnailUrl;
final String? releaseDate;
final int? runtimeMinutes;
final String? overview;
final List<WatchmodeSource>? sources;

Episode({
required this.id,
required this.name,
required this.episodeNumber,
required this.seasonNumber,
this.seasonId,
this.thumbnailUrl,
this.releaseDate,
this.runtimeMinutes,
this.overview,
this.sources,
});

factory Episode.fromJson(Map<String, dynamic> json) {
return Episode(
id: json['id'],
name: json['name'],
episodeNumber: json['episode_number'],
seasonNumber: json['season_number'],
seasonId: json['season_id'],
thumbnailUrl: json['thumbnail_url'],
releaseDate: json['release_date'],
runtimeMinutes: json['runtime_minutes'],
overview: json['overview'],
sources: json['sources'] != null
? (json['sources'] as List)
.map((source) => WatchmodeSource.fromJson(source))
.toList()
: null,
);
}
}
Step 6: Update the UI

Update your UI to display Watchmode-specific information like streaming sources and availability:

dartCopyWidget buildStreamingSourcesSection(Movie movie) {
// Assuming you've added a field to store Watchmode sources in your Movie model
if (movie.streamingSources == null || movie.streamingSources!.isEmpty) {
return const SizedBox.shrink();
}

return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Available on:',
style: Theme.of(context).textTheme.titleMedium?.copyWith(
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
Wrap(
spacing: 8,
runSpacing: 8,
children: movie.streamingSources!.map((source) => Chip(
label: Text(source.name),
avatar: source.type == 'sub'
? const Icon(Icons.subscriptions)
: source.type == 'free'
? const Icon(Icons.money_off)
: const Icon(Icons.shopping_cart),
)).toList(),
),
],
);
}
Step 7: Handle ID Mapping

If you need to maintain compatibility with your existing database that uses IMDb IDs:

dartCopy// Helper method to convert between IDs
Future<String?> getWatchmodeIdFromImdbId(String imdbId) async {
try {
final response = await client.get(
Uri.parse('$baseUrl/search/?apiKey=$apiKey&search_field=imdb_id&search_value=$imdbId'),
);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['title_results']?.isNotEmpty ?? false) {
        return data['title_results'][0]['id'].toString();
      }
    }
    return null;
} catch (e) {
return null;
}
}

// You could also download and store the Watchmode ID mapping file
Future<void> importWatchmodeIdMappings() async {
try {
final response = await http.get(Uri.parse('https://api.watchmode.com/datasets/title_id_map.csv'));
// Process CSV data and store in local database
// This is more efficient than making individual API calls for conversions
} catch (e) {
// Handle error
}
}
Step 8: Handle Rate Limiting

Implement a rate limiter to respect Watchmode's 120 requests per minute limit:

dartCopyclass RateLimiter {
final int maxRequests;
final Duration timeWindow;
final Queue<DateTime> _requestTimestamps = Queue();

RateLimiter({
this.maxRequests = 120,
this.timeWindow = const Duration(minutes: 1),
});

bool canMakeRequest() {
final now = DateTime.now();

    // Remove timestamps outside the time window
    while (_requestTimestamps.isNotEmpty && 
           now.difference(_requestTimestamps.first) > timeWindow) {
      _requestTimestamps.removeFirst();
    }
    
    return _requestTimestamps.length < maxRequests;
}

void registerRequest() {
_requestTimestamps.add(DateTime.now());
}

Duration timeUntilNextAvailable() {
if (canMakeRequest()) return Duration.zero;

    final oldestTimestamp = _requestTimestamps.first;
    return timeWindow - DateTime.now().difference(oldestTimestamp);
}
}

Integrate the rate limiter with your API client:

dartCopyfinal _rateLimiter = RateLimiter();

Future<T> _makeRateLimitedRequest<T>(Future<T> Function() request) async {
if (!_rateLimiter.canMakeRequest()) {
final delay = _rateLimiter.timeUntilNextAvailable();
await Future.delayed(delay);
}

_rateLimiter.registerRequest();
return await request();
}

// Use it in your methods
Future<List<Movie>> searchMovies(String query) async {
return _makeRateLimitedRequest(() async {
// Existing code...
});
}
Step 9: Testing

Create test cases to validate the new API integration
Compare results from OMDb and Watchmode to ensure data quality
Test error handling and edge cases

Step 10: Gradual Rollout

Consider implementing a feature flag to gradually switch from OMDb to Watchmode
Monitor API usage and any issues in production
Have a fallback mechanism to revert to OMDb if needed