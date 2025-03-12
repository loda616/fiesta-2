# Movie Details Workflow

## Overview

The Movie Details feature provides users with comprehensive information about a selected movie or TV show. It follows a clean architecture pattern that separates concerns across multiple layers, making the code maintainable and testable.

## Component Flow

1. **UI Layer** (`movie_details_page.dart`)
   - Triggered when a user navigates to a movie's detail page
   - Displays movie poster, backdrop, title, rating, description, streaming sources
   - Contains sub-components for streaming sources and recommendations
   - Responds to user actions (add to watchlist, play trailer)
   - Uses BLoC pattern via `MovieDetailsCubit` to manage state

2. **State Management** (`movie_details_cubit.dart`)
   - Manages UI states: `MovieDetailsInitial`, `MovieDetailsLoading`, `MovieDetailsError`, `MovieDetailsLoaded`
   - Handles business logic for loading movie details
   - Coordinates between multiple use cases
   - Transforms domain data to UI-friendly formats
   - Maintains watchlist state

3. **Use Cases** (`get_movie_details_usecase.dart`, `get_movie_recommendations_usecase.dart`)
   - Single-responsibility classes focused on specific features
   - Connects UI logic to domain repositories
   - Handles error wrapping with `Either<Failure, T>` pattern
   - Enforces business rules independent of data sources

4. **Repository Layer** (`movie_repository_impl.dart`)
   - Implements the repository interface defined in the domain layer
   - Chooses appropriate data sources based on the request
   - Handles data transformation between API models and domain entities
   - Manages caching strategies and offline capabilities
   - Error handling and conversion to domain failures

5. **Data Source** (`watchmode_api_source.dart`)
   - Communicates with external Watchmode API
   - Implements rate limiting to prevent API abuse
   - Handles HTTP errors and connection issues
   - Parses JSON responses into model objects

## Key Components

### `movie_details_page.dart`

Main UI component that:
- Uses `CustomScrollView` with `SliverAppBar` for collapsing header
- Displays backdrop image with parallax effect
- Shows movie metadata (title, year, rating, genres)
- Includes `StreamingSourcesSection` for "Where to Watch" information
- Contains `MovieRecommendations` for similar movies
- Provides TV show season navigation for series

### `streaming_sources_section.dart`

UI component that:
- Groups and displays available streaming platforms
- Shows subscription, rental, and purchase options
- Indicates pricing information when available
- Provides visual distinction between service types
- Handles "See All" expansion for many sources

### `movie_recommendations.dart`

UI component that:
- Displays horizontally scrollable list of similar content
- Shows movie posters with basic metadata
- Handles navigation to recommended movie details
- Gracefully handles missing images

## Data Flow

1. User navigates to movie details page with a movie ID parameter
2. Page initializes and calls `loadMovieDetails(movieId)` on the cubit
3. Cubit emits `MovieDetailsLoading` state
4. Cubit calls the `getMovieDetails` use case with the movie ID
5. Use case calls the repository's `getMovieDetails` method
6. Repository determines if ID is Watchmode or IMDB format
7. Repository calls the appropriate API source method
8. API source makes HTTP request and parses the response
9. Data flows back up through the layers:
   - API source returns a model object
   - Repository converts model to domain entity
   - Use case wraps entity in an `Either<Failure, Movie>` result
   - Cubit processes the result and emits appropriate state
   - UI rebuilds based on the new state

10. If successful, cubit also fetches recommendations:
    - Calls `getMovieRecommendations` use case
    - Repository and data source fetch similar titles
    - Results flow back to cubit in the same pattern
    - Cubit combines main movie and recommendations in `MovieDetailsLoaded` state

## Error Handling

- Network errors and API failures are captured in the data source
- Repository converts exceptions to domain-specific `Failure` objects
- Use case returns `Left<Failure>` for errors, `Right<T>` for success
- Cubit converts failures to user-friendly error messages
- UI displays error states with retry options

## State Management

The `MovieDetailsCubit` handles several states:

1. `MovieDetailsInitial`: Before any data loading begins
2. `MovieDetailsLoading`: During API requests
3. `MovieDetailsError`: When something fails (with error message)
4. `MovieDetailsLoaded`: Successfully loaded with movie and recommendations
   - Also tracks watchlist status for the movie

## Key Features

- **Trailer playback**: Opens trailer URL in external browser
- **Watchlist management**: Toggle movie in/out of watchlist
- **Streaming options**: Where to watch with pricing
- **TV show navigation**: Season and episode browsing for series
- **Similar content**: Recommendations based on current movie
- **Responsive design**: Adapts to different screen sizes

## Implementation Details

```dart
// Example of loading movie details in the Cubit
Future<void> loadMovieDetails(String movieId) async {
  emit(MovieDetailsLoading());

  try {
    final movieResult = await getMovieDetails(movieId);

    movieResult.fold(
      (failure) => emit(MovieDetailsError(failure.message)),
      (movie) async {
        _currentMovie = movie;
        _isInWatchlist = movie.isInWatchlist;

        // Get recommendations
        final recommendationsResult = await getMovieRecommendations(
            movie.watchmodeId ?? movie.imdbId
        );

        recommendationsResult.fold(
          (failure) {
            emit(MovieDetailsLoaded(movie, [], _isInWatchlist));
          },
          (recommendations) {
            emit(MovieDetailsLoaded(movie, recommendations, _isInWatchlist));
          },
        );
      },
    );
  } catch (e) {
    emit(MovieDetailsError(e.toString()));
  }
}
```