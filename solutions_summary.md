# Solutions Summary and Roadmap

This document provides a summary of the most critical solutions and a recommended roadmap for improving the application. The detailed descriptions of the issues and solutions can be found in the `bugs_report.md`, `performance_report.md`, and `refactoring_suggestions.md` files.

---

## High-Priority Tasks (Fix These First)

### 1. Secure the API Key

- **Problem**: The Watchmode API key is hardcoded in the source code.
- **Solution**:
  1. Create a `.env` file in the root of the project.
  2. Add the following line to the `.env` file: `API_KEY=your_api_key_here`
  3. Add `.env` to the `.gitignore` file.
  4. Use the `flutter_dotenv` package to load the API key at runtime.
  5. Update the dependency injection setup to use the loaded key.

### 2. Fix the State Management Bug

- **Problem**: The `MovieCubit` uses a single state for both popular movies and search results, causing data to be overwritten.
- **Solution**:
  1. In `lib/presentation/cubit/movie_cubit.dart`, create two new states: `PopularMoviesLoaded` and `SearchResultsLoaded`.
  2. Update the `MovieCubit` to emit these new states from the `loadPopularMovies` and `searchMovies` methods, respectively.
  3. Update the `PopularMoviesSection` and `SearchTab` to listen for the correct states.

### 3. Fix the Inefficient API Usage

- **Problem**: The application makes an excessive number of API calls (N+1 query problem).
- **Solution**:
  1. **For `searchMovies`**: Modify the `WatchmodeApiSource.searchMovies` method to not fetch the details for each movie. Update the UI to work with the basic information provided by the search API.
  2. **For `getMovieRecommendations`**: Investigate the Watchmode API for a batch endpoint to fetch multiple titles by ID. If one exists, use it. If not, consider reducing the number of recommendations or implementing a caching layer.

---

## Medium-Priority Tasks

### 4. Fix the Incorrect Sorting Logic

- **Problem**: Movie ratings are sorted as strings.
- **Solution**: In `lib/presentation/cubit/movie_cubit.dart`, parse the `imdbRating` as a `double` before sorting.

### 5. Fix the `getMovieDetails` Bug

- **Problem**: A missing `try-catch` block causes a compile-time error.
- **Solution**: In `lib/data/repositories/movie_repository_impl.dart`, wrap the call to `apiSource.getTitleSources` in a `try-catch` block.

### 6. Fix the Missing `await`

- **Problem**: A missing `await` breaks the rate limiting.
- **Solution**: In `lib/data/datasources/Watchmode/watchmode_api_source.dart`, add the `await` keyword to the `_makeRateLimitedRequest` call in `getMovieRecommendations`.

---

## Low-Priority Tasks (Quality of Life Improvements)

### 7. Refactor and Clean Up

- Consolidate the dependency injection setup.
- Complete the streaming sources feature.
- Replace magic strings with constants or enums.
- Improve the data loading logic in the `HomeTab`.

### 8. Improve UI and Accessibility

- Remove the fixed `textScaler`.
- Add `Equatable` to state and failure classes.
- Add keys to the `MovieCard` widgets.

By following this roadmap, you can significantly improve the security, performance, and maintainability of the application.
