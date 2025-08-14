# Bugs Report

This report details the bugs found in the codebase during the analysis.

---

### 1. Hardcoded API Key (Critical)

- **Location**:
  - `lib/di/injection.dart`
  - `lib/core/injection_container.dart`
- **Description**: The Watchmode API key is hardcoded in the dependency injection setup files. This is a major security vulnerability, as the key can be easily extracted from the application's source code.
- **Impact**: Anyone with access to the source code can steal the API key and use it to make unauthorized requests to the Watchmode API, which could lead to service disruption or financial loss.
- **Recommendation**: Store the API key in a secure location, such as a `.env` file, and load it at runtime. The `.env` file should be added to `.gitignore` to prevent it from being committed to version control.

---

### 2. State Management Bug in MovieCubit (High)

- **Location**: `lib/presentation/cubit/movie_cubit.dart` and `lib/presentation/home/tabs/sections/popular_movies_section.dart`
- **Description**: The `MovieCubit` uses the same `MovieSearchLoaded` state to manage both the list of popular movies and the list of search results. When a user performs a search, the `PopularMoviesSection` on the home screen is rebuilt with the search results, overwriting the list of popular movies.
- **Impact**: This bug leads to a confusing and incorrect user experience. The user will see search results where they expect to see popular movies.
- **Recommendation**: Create separate states for popular movies and search results (e.g., `PopularMoviesLoaded` and `SearchResultsLoaded`). Alternatively, create separate Cubits for each feature.

---

### 3. Incorrect Sorting Logic (Medium)

- **Location**: `lib/presentation/cubit/movie_cubit.dart`
- **Description**: The `searchMovies` method in `MovieCubit` sorts movies by their IMDb rating using string comparison.
- **Impact**: This leads to incorrect sorting. For example, a movie with a rating of "10.0" will be considered less than a movie with a rating of "9.0".
- **Recommendation**: Parse the rating as a number (e.g., a `double`) before comparing. Handle cases where the rating is null or not a valid number.

---

### 4. Bug in `getMovieDetails` (Medium)

- **Location**: `lib/data/repositories/movie_repository_impl.dart`
- **Description**: In the `getMovieDetails` method of `MovieRepositoryImpl`, there is a call to `print('Failed to get streaming sources: $e');` without a surrounding `try-catch` block. The variable `e` is not defined in this scope.
- **Impact**: This will cause a compile-time error, preventing the application from being built.
- **Recommendation**: Wrap the call to `apiSource.getTitleSources(watchmodeId)` in a `try-catch` block to handle potential errors.

---

### 5. Missing `await` in `getMovieRecommendations` (Medium)

- **Location**: `lib/data/datasources/Watchmode/watchmode_api_source.dart`
- **Description**: The `getMovieRecommendations` method in `WatchmodeApiSource` is missing an `await` on the `_makeRateLimitedRequest` call.
- **Impact**: The rate limiting will not work correctly for this method. The method will not wait for the rate limiter to allow the request, which could lead to exceeding the API's rate limits and getting blocked.
- **Recommendation**: Add the `await` keyword before the `_makeRateLimitedRequest` call.
